"""Controlled recommendation-query comparisons, not a general equivalence proof.
Default: RDF checks only. --neo4j creates and removes its OWN isolated container.
No existing database/container is accepted or modified.
"""
import argparse, csv, hashlib, io, itertools, json, platform, re, subprocess, time, uuid
from pathlib import Path
from importlib.metadata import version
from support import require
from rdflib import Graph, Namespace, RDF, RDFS, Literal, URIRef
from pyshacl import validate
from owlrl import DeductiveClosure, RDFS_Semantics
ROOT=Path(__file__).resolve().parent
EX=Namespace('https://example.org/')
SPARQL=(ROOT/'source/04_recommend.rq').read_text()
CYPHER=re.split(r'^// \d+\. .*\n',(ROOT/'source/queries.cypher').read_text(),flags=re.M)[-1].strip().rstrip(';')
LOADER=(ROOT/'source/catalog.cypher').read_text()
SHAPES=Graph().parse(ROOT/'source/shapes.ttl')

def graph():return Graph().parse(ROOT/'source/catalog.ttl')

def term(v):
    if isinstance(v,Literal):
        return {'kind':'literal','value':str(v),'datatype':str(RDF.langString if v.language else (v.datatype or EXTERNAL_STRING)),'language':v.language}
    return {'kind':'resource','value':str(v)}
EXTERNAL_STRING='http://www.w3.org/2001/XMLSchema#string'
def typed_rows(g): return sorted([[term(x) for x in r] for r in g.query(SPARQL)],key=lambda x:json.dumps(x,sort_keys=True))
def lpg_term(v):
    if isinstance(v,str): return {'kind':'literal','value':v,'datatype':EXTERNAL_STRING,'language':None}
    return {'kind':'lpg-value','value':v}
RELS={'likesTopic':'LIKES_TOPIC','about':'ABOUT','completed':'COMPLETED','requires':'REQUIRES','learner':'LEARNER','course':'COURSE'}
TYPES={'Person','Course','Topic','OnlineCourse','Completion'}
def key(v): return str(v).removeprefix(str(EX))
def rdf_state(g):
    nodes=set()
    for a,b,c in g:
        if b in [EX[x] for x in RELS] or (b==RDF.type and key(c) in TYPES):
            nodes.add(a)
            if b!=RDF.type: nodes.add(c)
    require(len({key(n) for n in nodes})==len(nodes),'Duplicate RDF identity keys after shortening')
    out=[]
    for n in nodes:
        labels=sorted(key(t) for t in g.objects(n,RDF.type) if key(t) in TYPES)
        props={k:[term(v) for v in sorted(g.objects(n,EX[k]),key=str)] for k in ['id','title'] if list(g.objects(n,EX[k]))}
        # Application keys for non-course identities derive from the resource IRI.
        if 'Course' not in labels and 'OnlineCourse' not in labels: props['id']=[term(Literal(key(n)))]
        out.append([key(n),labels,props])
    edges=sorted(set((key(a),RELS[key(b)],key(c)) for a,b,c in g if key(b) in RELS))
    return {'nodes':sorted(out,key=lambda x:x[0]),'edges':[list(e) for e in edges]}
def lpg_state(raw):
    nodes,edges=raw
    ns=[]
    require(len({n[0] for n in nodes})==len(nodes),'Duplicate exported identity keys')
    for identity,labels,identifier,title in nodes:
        props={k:v[0] for k,v in [('id',identifier),('title',title)] if v}
        ns.append([identity,sorted(t for t in labels if t in TYPES),{k:[lpg_term(v)] for k,v in props.items() if k in ['id','title']}])
    return {'nodes':sorted(ns,key=lambda x:x[0]),'edges':[list(x) for x in sorted(set(tuple(e) for e in edges))]}
def integrity_issues(g):
    issues=[];ids=[]
    for a,b,c in g:
        if key(b) in RELS and not (isinstance(a,URIRef) and isinstance(c,URIRef)):issues.append('relationship endpoint is not an IRI')
    if (EX.maya,RDF.type,EX.Person) not in g:issues.append('learner lacks Person membership')
    for c in g.subjects(RDF.type,EX.Course):
        for field in ['id','title']:
            vs=list(g.objects(c,EX[field]))
            if len(vs)!=1 or not isinstance(vs[0],Literal) or vs[0].language or str(vs[0].datatype or EXTERNAL_STRING)!=EXTERNAL_STRING:issues.append('non-scalar string '+field)
        ids.extend(str(v) for v in g.objects(c,EX.id))
    if len(ids)!=len(set(ids)):issues.append('course key collision')
    for a,b in g.subject_objects(EX.requires):
        if (b,RDF.type,EX.Course) not in g:issues.append('prerequisite lacks Course membership')
    return sorted(set(issues))
QUERY_RELS={'LIKES_TOPIC','ABOUT','COMPLETED','REQUIRES'}
def query_alignment_issues(g):
    issues=[]
    relevant={EX.maya}|set(g.subjects(RDF.type,EX.Person))|set(g.subjects(RDF.type,EX.Course))
    if any(not isinstance(n,URIRef) for n in relevant):issues.append('relevant resource is not an IRI')
    for a,b,c in g:
        if b in [EX[x] for x in ['likesTopic','about','completed','requires']] and not (isinstance(a,URIRef) and isinstance(c,URIRef)):
            issues.append('relationship endpoint is not an IRI')
    for c in g.subjects(RDF.type,EX.Course):
        for field in ['id','title']:
            values=list(g.objects(c,EX[field]))
            if len(values)>1 or any(not isinstance(v,Literal) or v.language or str(v.datatype or EXTERNAL_STRING)!=EXTERNAL_STRING for v in values):
                issues.append('projection requires zero or one untagged string '+field)
    return sorted(set(issues))
def query_state(state):
    edges=[x for x in state['edges'] if x[1] in QUERY_RELS]
    members={x for edge in edges for x in [edge[0],edge[2]]}
    members.update(n[0] for n in state['nodes'] if {'Person','Course'} & set(n[1]) or n[0]=='maya')
    nodes=[]
    for identity,labels,props in state['nodes']:
        if identity in members:
            fields={k:v for k,v in props.items() if 'Course' in labels and k in ['id','title']}
            nodes.append([identity,[x for x in labels if x in ['Person','Course']],fields])
    return {'nodes':nodes,'edges':edges}
def anchor_aligned(rdf,lpg):
    expected=['maya'] if any(n[0]=='maya' and 'Person' in n[1] for n in rdf['nodes']) else []
    actual=[n[0] for n in lpg['nodes'] if 'Person' in n[1] and n[2].get('id')==[lpg_term('maya')]]
    return sorted(actual)==expected
STATE_QUERY="""CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'STATEKEY' AS case_id,[ns,es] AS rows;"""
def rows(g,q=SPARQL):return sorted([[str(x) for x in row] for row in g.query(q)])
def shell(*args,**kwargs):return subprocess.run(args,check=True,text=True,capture_output=True,**kwargs)

def cases():
    cases=[]
    def add(name,g,mutation,expected,conforms=True,contract=True,note='',query=CYPHER,compare=True):
        cases.append(dict(id=name,g=g,mutation=mutation,expected=expected,expected_conforms=conforms,
                          contract=contract,note=note,query=query,compare=compare))
    c2=[['c2','Graph Search']]
    add('C01-baseline',graph(),'',c2)
    g=graph();g.add((EX.c2,EX.requires,EX.c4));add('C02-unmet-prerequisite',g,"MATCH (a:Course {id:'c2'}),(b:Course {id:'c4'}) CREATE (a)-[:REQUIRES]->(b);",[])
    g=graph();g.add((EX.maya,EX.completed,EX.c2));add('C03-already-completed',g,"MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);",[])
    g=graph();g.add((EX.maya,EX.likesTopic,EX.data));g.add((EX.c2,EX.about,EX.data))
    add('C04-two-matching-topics',g,"MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}),(c:Course {id:'c2'}) CREATE (m)-[:LIKES_TOPIC]->(t) CREATE (c)-[:ABOUT]->(t);",c2+[['c3','Query Patterns']])
    g=graph();g.remove((EX.graphs,RDF.type,EX.Topic));add('C05-untyped-topic',g,"MATCH (t:Topic {id:'graphs'}) REMOVE t:Topic;",c2,note='Topic typing is deliberately not required by this query contract.')
    g=graph();g.remove((EX.c2,EX.title,None));add('C06-missing-title',g,"MATCH (c:Course {id:'c2'}) REMOVE c.title;",[],False,False,'Query-aligned; intake integrity fails and both queries omit the course.')
    g=graph();g.remove((EX.maya,RDF.type,EX.Person));add('C07-untyped-learner',g,"MATCH (m:Person {id:'maya'}) REMOVE m:Person;",[],False,False,'Query-aligned absence of Person membership; intake integrity fails.')
    g=graph();g.add((EX.c2,EX.requires,EX.c9));add('C08-non-Course-prerequisite',g,"MATCH (c:Course {id:'c2'}) CREATE (c)-[:REQUIRES]->({id:'c9'});",[],False,False,'SHACL rejects untyped prerequisite; the query still checks it.')
    g=graph();g.add((EX.c2,EX.requires,EX.c2));add('C09-self-prerequisite',g,"MATCH (c:Course {id:'c2'}) CREATE (c)-[:REQUIRES]->(c);",[],note='A cycle can pass these shapes; absence of cycles is not an intake guarantee.')
    g=graph();g.add((EX.c1,EX.requires,EX.c4));add('C10-direct-not-transitive-policy',g,"MATCH (a:Course {id:'c1'}),(b:Course {id:'c4'}) CREATE (a)-[:REQUIRES]->(b);",c2,note='Both policies check direct prerequisites only; agreement does not establish a transitive or real-world suitability policy.')
    g=graph();g.remove((EX.c2,EX.id,None));add('C11-missing-id',g,"MATCH (c:Course {id:'c2'}) REMOVE c.id;",[],False,False)
    g=graph();g.add((EX.c2,EX.title,Literal('Alternate title')))
    add('B01-multivalued-title',g,"MATCH (c:Course {id:'c2'}) SET c.title=['Graph Search','Alternate title'];",[['c2','Alternate title'],['c2','Graph Search']],False,False,'RDF has two scalar title bindings; this LPG representation returns one list value.',compare=False)
    g=graph();g.add((EX.maya,EX.completed,EX.c1));g.add((EX.maya,EX.completed,EX.c1))
    add('B02-parallel-completions',g,"MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c);",c2,note='Existence-based recommendation remains equal, but occurrence counts differ.')
    g=graph();g.remove((EX.c2,RDF.type,EX.Course));g.add((EX.c2,RDF.type,EX.OnlineCourse));g.add((EX.OnlineCourse,RDFS.subClassOf,EX.Course));DeductiveClosure(RDFS_Semantics).expand(g)
    add('B03-asymmetric-inference',g,"MATCH (c:Course {id:'c2'}) REMOVE c:Course SET c:OnlineCourse;",c2,True,False,'RDFS materialization adds Course on RDF side; LPG lacks aligned Course label.',compare=False)
    g=graph()
    for i in [1,2]:g.add((EX[f'e{i}'],RDF.type,EX.Completion));g.add((EX[f'e{i}'],EX.learner,EX.maya));g.add((EX[f'e{i}'],EX.course,EX.c1))
    add('B04-explicit-completion-events',g,"MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (e1:Completion {id:'e1'})-[:LEARNER]->(m) CREATE (e1)-[:COURSE]->(c) CREATE (e2:Completion {id:'e2'})-[:LEARNER]->(m) CREATE (e2)-[:COURSE]->(c);",c2,note='Separate event identifiers retain two occurrences on both sides.')
    # Exhaustive 4 x 8 x 4 bounded factor grid, not arbitrary graphs.
    for reqmask,donemask,likemask in itertools.product(range(4),range(8),range(4)):
        req={['c1','c3'][i] for i in range(2) if reqmask&(1<<i)}
        done={['c1','c2','c3'][i] for i in range(3) if donemask&(1<<i)}
        liked={['graphs','data'][i] for i in range(2) if likemask&(1<<i)}
        g=graph();g.remove((EX.c2,EX.requires,None));g.remove((EX.maya,EX.completed,None));g.remove((EX.maya,EX.likesTopic,None))
        for x in req:g.add((EX.c2,EX.requires,EX[x]))
        for x in done:g.add((EX.maya,EX.completed,EX[x]))
        for x in liked:g.add((EX.maya,EX.likesTopic,EX[x]))
        mutation="MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r;"
        for x in sorted(req):mutation+=f" MATCH (c:Course {{id:'c2'}}),(p:Course {{id:'{x}'}}) CREATE (c)-[:REQUIRES]->(p);"
        for x in sorted(done):mutation+=f" MATCH (m:Person {{id:'maya'}}),(c:Course {{id:'{x}'}}) CREATE (m)-[:COMPLETED]->(c);"
        for x in sorted(liked):mutation+=f" MATCH (m:Person {{id:'maya'}}),(t:Topic {{id:'{x}'}}) CREATE (m)-[:LIKES_TOPIC]->(t);"
        # Separately expressed set predicate, authored in the same project, no SPARQL/Cypher parsing or query calls.
        catalog={
            'c1':('Graph Basics',{'graphs'},set()),
            'c2':('Graph Search',{'graphs'},req),
            'c3':('Query Patterns',{'data'},{'c1'}),
            'c4':('Data Ethics',{'ethics'},set())}
        expected=sorted([[identifier,title] for identifier,(title,topics,required) in catalog.items()
                         if topics & liked and identifier not in done and required <= done])
        add(f'G-{reqmask}{donemask}{likemask}',g,mutation,expected)
    g=graph();g.add((EX.c2,EX.requires,EX.c3));g.add((EX.maya,EX.completed,EX.c3))
    add('C12-all-multiple-prerequisites-completed',g,"MATCH (c:Course {id:'c2'}),(r:Course {id:'c3'}),(m:Person {id:'maya'}) CREATE (c)-[:REQUIRES]->(r) CREATE (m)-[:COMPLETED]->(r);",c2)
    g=graph();g.add((EX.c2,RDF.type,EX.OnlineCourse));g.add((EX.OnlineCourse,RDFS.subClassOf,EX.Course))
    add('C13-aligned-membership-control',g,"MATCH (c:Course {id:'c2'}) SET c:OnlineCourse;",c2,note='Both query-visible Course memberships are explicit; no OWL execution is claimed.')
    return cases

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--neo4j',action='store_true',help='Create/remove an isolated temporary Neo4j container')
    p.add_argument('--image',default='neo4j:5.26.30',help='Image tag or immutable image ID, already available locally')
    p.add_argument('--report',type=Path,default=ROOT/'results/run.json')
    a=p.parse_args()
    artifacts=[a.report,a.report.with_suffix('.cypher'),a.report.with_suffix('.stdout.txt'),a.report.with_suffix('.failure.txt')]
    require(not any(f.exists() for f in artifacts),'Refusing to overwrite retained evidence; choose a fresh --report path')
    a.report.parent.mkdir(parents=True,exist_ok=True)
    allcases=cases();results=[];script=[]
    for c in allcases:
        issues=integrity_issues(c['g']);require(bool(issues)==(not c['contract']) or c['id']=='B03-asymmetric-inference',(c['id'],issues))
        actual=rows(c['g']);conforms=bool(validate(c['g'],shacl_graph=SHAPES,inference='none')[0])
        if actual!=sorted(c['expected']):raise AssertionError((c['id'],'RDF',actual,c['expected']))
        if conforms!=c['expected_conforms']:raise AssertionError((c['id'],'SHACL',conforms))
        results.append(dict(case=c['id'],declared_query_aligned=c['compare'],verified_query_aligned=None,fixture_integrity_pass=not issues,verified_fixture_state_equal=None,verified_fixture_integrity=None,shacl_conforms=conforms,rdf_rows=actual,cypher_rows=None,note=c['note'],rdf_typed_rows=typed_rows(c['g']),rdf_state=rdf_state(c['g']),integrity_issues=issues,query_alignment_issues=query_alignment_issues(c['g'])))
        script.extend(['MATCH (n) DETACH DELETE n;',LOADER,"MATCH (n) SET n._source=n.id;",c['mutation'],STATE_QUERY.replace('STATEKEY','S-'+c['id']),f"CALL {{ CALL {{ {c['query']} }} RETURN collect([id,title]) AS result_rows }} RETURN '{c['id']}' AS case_id, result_rows AS rows;"])
        if c['id']=='B02-parallel-completions':
            count=int(list(c['g'].query('PREFIX ex:<https://example.org/> SELECT (COUNT(?c) AS ?n) WHERE { ex:maya ex:completed ?c }'))[0][0]);require(count==1,'RDF occurrence count')
            results[-1]['rdf_occurrence_count']=count
            script.append("MATCH (:Person {id:'maya'})-[r:COMPLETED]->() RETURN 'D-parallel-count' AS case_id, count(r) AS rows;")
        if c['id']=='B04-explicit-completion-events':
            count=len({e for e in c['g'].subjects(EX.learner,EX.maya) if (e,RDF.type,EX.Completion) in c['g'] and (e,EX.course,EX.c1) in c['g']});require(count==2,'RDF event count');results[-1]['rdf_event_count']=count
            script.append("MATCH (e:Completion)-[:LEARNER]->(:Person {id:'maya'}), (e)-[:COURSE]->(:Course {id:'c1'}) RETURN 'D-event-count' AS case_id, count(DISTINCT e) AS rows;")
    runtime=None
    if a.neo4j:
        # No caller-provided existing container: all DELETE statements are confined
        # to the unique instance created here. No host ports or existing volumes.
        name='kg-equivalence-'+uuid.uuid4().hex[:10]
        info=json.loads(shell('docker','image','inspect',a.image).stdout)[0]
        image_id=info['Id']
        shell('docker','run','-d','--name',name,'--hostname','localhost','--network','none','--memory','2g',
              '-e','NEO4J_AUTH=none','-e','NEO4J_server_memory_heap_initial__size=256m',
              '-e','NEO4J_server_memory_heap_max__size=512m','-e','NEO4J_server_memory_pagecache_size=128m',image_id)
        try:
            def run(q,timeout=240):
                return shell('docker','exec','-i',name,'cypher-shell','--format','plain','--non-interactive',input=q,timeout=timeout).stdout
            for n in range(60):
                try:run('RETURN 1 AS ready;',15);break
                except (subprocess.CalledProcessError,subprocess.TimeoutExpired):
                    if n==59:raise
                    time.sleep(2)
            ver=list(csv.DictReader(io.StringIO(run('CALL dbms.components() YIELD versions,edition RETURN versions[0] AS version,edition;')),skipinitialspace=True))[0]
            if not ver['version'].startswith('5.26.'):raise RuntimeError('This protocol targets Neo4j 5.26.x; actual '+ver['version'])
            script_text='\n'.join(script)
            output=run(script_text); parsed={}
            # cypher-shell plain output quotes scalar strings, but does not CSV-
            # quote list-valued columns. Decode the first JSON string and then
            # the remaining JSON value instead of splitting nested array commas.
            a.report.parent.mkdir(parents=True,exist_ok=True)
            a.report.with_suffix('.cypher').write_text(script_text)
            a.report.with_suffix('.stdout.txt').write_text(output)
            decoder=json.JSONDecoder()
            for line in output.splitlines():
                try:
                    key,pos=decoder.raw_decode(line.lstrip())
                    if isinstance(key,str) and key.startswith(('C','B','G-','D-','S-')):
                        require(key not in parsed,('duplicate output',key))
                        parsed[key]=json.loads(line.lstrip()[pos:].lstrip(', '))
                except (ValueError,TypeError):
                    continue
            require(len(parsed)==2*len(allcases)+2,('missing output',len(parsed)))
            for c,r in zip(allcases,results):
                neo=sorted(parsed[c['id']],key=lambda row:json.dumps(row));r['cypher_rows']=neo
                r['cypher_typed_rows']=sorted([[lpg_term(v) for v in row] for row in neo],key=lambda x:json.dumps(x,sort_keys=True))
                r['result_equal']=r['cypher_typed_rows']==r['rdf_typed_rows']
                r['cypher_state']=lpg_state(parsed['S-'+c['id']])
                r['verified_fixture_state_equal']=r['cypher_state']==r['rdf_state']
                require(r['verified_fixture_state_equal']==(c['id'] not in ['B01-multivalued-title','B03-asymmetric-inference']),(c['id'],'state mismatch',r['rdf_state'],r['cypher_state']))
                r['verified_fixture_integrity']=r['fixture_integrity_pass'] and r['verified_fixture_state_equal']
                r['verified_query_aligned']=not r['query_alignment_issues'] and query_state(r['rdf_state'])==query_state(r['cypher_state']) and anchor_aligned(r['rdf_state'],r['cypher_state'])
                require(r['verified_query_aligned']==r['declared_query_aligned'],(c['id'],'query alignment mismatch'))
                if c['compare']:require(r['result_equal'],(c['id'],neo,r['rdf_rows']))
                else:require(not r['result_equal'],c['id'])
            b1=next(r for r in results if r['case']=='B01-multivalued-title')
            require(b1['cypher_rows']==[['c2',['Graph Search','Alternate title']]],'B01 expected discrepancy')
            b3=next(r for r in results if r['case']=='B03-asymmetric-inference');require(b3['cypher_rows']==[],'B03 expected discrepancy')
            require(parsed['D-parallel-count']==2,'parallel count');require(parsed['D-event-count']==2,'event count')
            next(r for r in results if r['case']=='B02-parallel-completions')['cypher_occurrence_count']=parsed['D-parallel-count']
            next(r for r in results if r['case']=='B04-explicit-completion-events')['cypher_event_count']=parsed['D-event-count']
            runtime={'version':ver,'image_reference':a.image,'image_id':image_id,'repo_digests':info.get('RepoDigests',[]),'architecture':info.get('Architecture'),'os':info.get('Os'),'network':'none','host_ports':[],'existing_database_touched':False}
        except Exception as exc:
            logs=shell('docker','logs',name).stdout
            detail=getattr(exc,'stderr',None) or str(exc)
            a.report.with_suffix('.failure.txt').write_text(detail+'\n'+logs)
            raise RuntimeError(detail[-1500:]) from exc
        finally:shell('docker','rm','-fv',name)
    report={'status':'pass' if a.neo4j else 'rdf-only-pass-cypher-not-run','scope':'145 controlled datasets: 17 curated cases and a 128-case bounded factor grid. Not a benchmark, proof for arbitrary graphs, or independent human review.',
            'python':platform.python_version(),'dependencies':{n:version(n) for n in ['rdflib','pyshacl','owlrl']},'neo4j':runtime,
            'inputs':{str(f.relative_to(ROOT)):hashlib.sha256(f.read_bytes()).hexdigest() for f in [Path(__file__),ROOT/'support.py',*sorted((ROOT/'source').glob('*'))]},'case_count':len(results),'results':results}
    a.report.parent.mkdir(parents=True,exist_ok=True);a.report.write_text(json.dumps(report,indent=2)+'\n')
    print(report['status'],len(results),'datasets;',a.report)
if __name__=='__main__':main()
