"""Supplementary controls; simulated engine-output corruption is not an engine run."""
import argparse,json,sys,tempfile,subprocess,types
from support import fresh_outputs
from pathlib import Path
import run_experiment as rx
from rdflib import Literal,RDF,BNode,URIRef
ROOT=Path(__file__).resolve().parent

def child(kind):
    raw=(ROOT/'results/paired-run.stdout.txt').read_text()
    if kind=='answer':
        raw='\n'.join('"C01-baseline", []' if x.startswith('"C01-baseline",') else x for x in raw.splitlines())
    elif kind=='state':
        baseline=next(x for x in raw.splitlines() if x.startswith('"S-C01-baseline",'))
        raw='\n'.join(baseline.replace('S-C01-baseline','S-C05-untyped-topic') if x.startswith('"S-C05-untyped-topic",') else x for x in raw.splitlines())
    def simulated(*cmd,**kw):
        if cmd[:3]==('docker','image','inspect'):out=json.dumps([{'Id':'SIMULATED-NOT-ENGINE-EVIDENCE'}])
        elif cmd[:2] in [('docker','run'),('docker','rm'),('docker','logs')]:out='SIMULATED ONLY'
        elif cmd[:2]==('docker','exec'):
            q=kw['input']
            out='ready\n1\n' if q.startswith('RETURN 1') else ('version, edition\n"5.26.30", "community"\n' if q.startswith('CALL dbms.components') else raw)
        else:raise RuntimeError('unexpected simulated command')
        return types.SimpleNamespace(stdout=out)
    rx.shell=simulated
    with tempfile.TemporaryDirectory() as d:
        sys.argv=['control','--neo4j','--report',str(Path(d)/'bad.json')]
        try:rx.main()
        except RuntimeError as exc:
            if kind=='unmodified':raise RuntimeError('Unmodified simulated output rejected') from exc
            expected='C01-baseline' if kind=='answer' else 'C05-untyped-topic'
            rx.require(expected in str(exc.__cause__ or exc),'Unexpected rejection reason: '+str(exc))
            return
        if kind=='unmodified':return
        raise RuntimeError('Corrupted output was accepted')

def main():
    if '--child' in sys.argv:child(sys.argv[-1]);return
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--out',type=Path,default=ROOT/'results');args=parser.parse_args()
    path=args.out/'revision-checks.json';fresh_outputs([path])
    checks={}
    g=rx.graph();g.set((rx.EX.c2,rx.EX.title,Literal('Graph Search',lang='en')))
    rx.require('non-scalar string title' in rx.integrity_issues(g),'language boundary not rejected')
    rx.require(rx.typed_rows(g)!=[[rx.lpg_term('c2'),rx.lpg_term('Graph Search')]],'language tag lost')
    rx.require(rx.term(Literal('Graph Search',lang='en'))['datatype']==str(RDF.langString),'Language datatype mislabeled')
    checks['language_tag_retained_and_rejected']=True
    g=rx.graph();g.add((rx.EX.maya,rx.EX.likesTopic,Literal('ethics')));g.add((rx.EX.c4,rx.EX.about,Literal('ethics')))
    rx.require('relationship endpoint is not an IRI' in rx.integrity_issues(g),'literal endpoint not rejected');checks['literal_endpoint_rejected']=True
    g=rx.graph();g.add((rx.EX.other,RDF.type,rx.EX.Course));g.add((rx.EX.other,rx.EX.id,Literal('c2')));g.add((rx.EX.other,rx.EX.title,Literal('Other')))
    rx.require('course key collision' in rx.integrity_issues(g),'collision not rejected');checks['course_identity_collision_rejected']=True
    g=rx.graph();g.add((BNode('outside-scope'),RDF.type,rx.EX.Course))
    rx.require('relevant resource is not an IRI' in rx.query_alignment_issues(g),'Non-IRI class instance admitted')
    checks['non_iri_class_instance_outside_mapping']=True
    g=rx.graph();g.add((rx.EX['https://outside.example/item'],RDF.type,rx.EX.Topic));g.add((URIRef('https://outside.example/item'),RDF.type,rx.EX.Topic))
    try:rx.rdf_state(g)
    except RuntimeError as exc:rx.require('Duplicate RDF identity keys' in str(exc),str(exc))
    else:raise RuntimeError('Shortened RDF identity collision admitted')
    checks['shortened_rdf_identity_collision_rejected']=True
    retained=json.loads((ROOT/'results/paired-run.json').read_text())
    for name in ['C06-missing-title','C07-untyped-learner','C08-non-Course-prerequisite','C11-missing-id']:
        record=next(r for r in retained['results'] if r['case']==name)
        rx.require(record['verified_query_aligned'] and not record['fixture_integrity_pass'] and not record['shacl_conforms'],name)
    base=next(r for r in retained['results'] if r['case']=='C01-baseline')
    extended=json.loads(json.dumps(base['cypher_state']));extended['nodes'].append(['isolated',[],{}]);extended['nodes'].sort(key=lambda n:n[0])
    rx.require(rx.query_state(extended)==rx.query_state(base['rdf_state']),'Irrelevant node changed query alignment')
    rx.require(extended!=base['rdf_state'],'Full fixture check failed to distinguish extra node')
    checks['query_alignment_separated_from_integrity_and_intake']=True
    checks['full_fixture_check_is_stricter_than_query_projection']=True
    q=rx.SPARQL
    inner='''  FILTER NOT EXISTS {
    ?c ex:requires ?required .
    FILTER NOT EXISTS { ex:maya ex:completed ?required }
  }'''
    rx.require(inner in q,'query prerequisite block changed')
    mutants={
      'remove-prerequisites':q.replace(inner,''),
      'remove-completed-exclusion':q.replace('  FILTER NOT EXISTS { ex:maya ex:completed ?c }',''),
      'require-typed-topic':q.replace('ex:likesTopic ?topic .','ex:likesTopic ?topic . ?topic a ex:Topic .'),
      'remove-person-test':q.replace('ex:maya a ex:Person ;','ex:maya'),
      'remove-distinct':q.replace('SELECT DISTINCT','SELECT'),
      'at-most-one-prerequisite':q.replace(inner,inner+'\n FILTER NOT EXISTS { ?c ex:requires ?a, ?b . FILTER(?a != ?b) }')}
    kills={name:[c['id'] for c in rx.cases() if rx.rows(c['g'],mutant)!=sorted(c['expected'])] for name,mutant in mutants.items()}
    rx.require(all(kills.values()),'surviving mutant')
    rx.require('C12-all-multiple-prerequisites-completed' in kills['at-most-one-prerequisite'],'positive control missing')
    for optimized in [False,True]:
        for kind in ['answer','state','unmodified']:
            args=[sys.executable]+(['-O'] if optimized else [])+[str(Path(__file__).resolve()),'--child',kind]
            result=subprocess.run(args,text=True,capture_output=True)
            rx.require(result.returncode==0,result.stderr)
            checks[f'simulated_{kind}_'+('accepted' if kind=='unmodified' else 'corruption_rejected')+f'_optimized_{optimized}']=True
    # Refusal happens before the RDF work or Docker invocation.
    with tempfile.TemporaryDirectory() as d:
        p=Path(d)/'kept.json';p.write_text('retained');old=sys.argv
        sys.argv=['check','--report',str(p)]
        try:
            try:rx.main()
            except RuntimeError as exc:rx.require('Refusing to overwrite' in str(exc),str(exc))
            else:raise RuntimeError('Evidence overwrite accepted')
        finally:sys.argv=old
        rx.require(p.read_text()=='retained','retained evidence changed')
    with tempfile.TemporaryDirectory() as d:
        result=subprocess.run([sys.executable,str(ROOT/'run_experiment.py'),'--report',str(Path(d)/'rdf.json')],capture_output=True,text=True)
        rx.require(result.returncode==0,result.stderr)
        rdf=json.loads((Path(d)/'rdf.json').read_text())
        rx.require(all(r['verified_query_aligned'] is None and r['verified_fixture_state_equal'] is None and r['verified_fixture_integrity'] is None for r in rdf['results']),'RDF-only report asserts paired verification')
    checks['rdf_only_keeps_paired_verification_null']=True
    checks['existing_evidence_preserved']=True
    data={'scope':'Boundary checks and harness simulations, not additional paired engine execution','checks':checks,'mutant_killers':kills}
    path.write_text(json.dumps(data,indent=2)+'\n');print('Supplementary controls passed; all six deliberately wrong queries rejected.')
if __name__=='__main__':main()
