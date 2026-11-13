"""Run the synthetic catalog checks in an EMPTY dedicated Neo4j container.
Uses Docker + cypher-shell; no Python database driver is required.
"""
import argparse, csv, io, json, subprocess, time, re
from pathlib import Path

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--container',required=True,help='Dedicated Neo4j container with an empty graph')
parser.add_argument('--lab',type=Path,default=Path(__file__).resolve().parent)
parser.add_argument('--report',type=Path)
args=parser.parse_args()

def run(text,rows=True,parameters=None,output_format="plain"):
    command=['docker','exec','-i',args.container,'cypher-shell','--format',output_format,'--non-interactive']
    if parameters:
        assert all(re.fullmatch(r'[A-Za-z_][A-Za-z0-9_]*',key) for key in parameters)
        expression='{'+', '.join(key+': '+json.dumps(value) for key,value in parameters.items())+'}'
        command.extend(['-P',expression])
    proc=subprocess.run(command,input=text,text=True,capture_output=True,timeout=60)
    if proc.returncode:raise RuntimeError(proc.stderr[-2000:] or proc.stdout[-2000:])
    if not rows:return proc.stdout
    return list(csv.DictReader(io.StringIO(proc.stdout.strip()),skipinitialspace=True))

for attempt in range(45):
    try:
        run('RETURN 1 AS ready;');break
    except (RuntimeError,subprocess.TimeoutExpired):
        if attempt==44:raise
        time.sleep(2)
version=run('CALL dbms.components() YIELD versions, edition RETURN versions[0] AS version, edition;')[0]
assert run('MATCH (n) RETURN count(n) AS count;')[0]['count']=='0','Use an empty dedicated exercise database.'
loader=(args.lab/'catalog.cypher').read_text()
run(loader,False);run(loader,False)
assert run('MATCH (n) RETURN count(n) AS count;')[0]['count']=='9'
assert run('MATCH ()-[r]->() RETURN count(r) AS count;')[0]['count']=='10'
# Execute the published query blocks verbatim, including the parameterized listing.
blocks=re.split(r'^// \d+\. .*\n',(args.lab/'queries.cypher').read_text(),flags=re.M)[1:]
assert len(blocks)==5
expected=[
    [{'id':'c1','title':'Graph Basics'},{'id':'c2','title':'Graph Search'}],
    [{'id':'c1'},{'id':'c3'},{'id':'c4'}],
    [{'topic':'graphs','courses':'2'},{'topic':'data','courses':'1'},{'topic':'ethics','courses':'1'}],
    [{'required':'c1'}],
    [{'id':'c2','title':'Graph Search'}],
]
for i,block in enumerate(blocks):
    assert run(block,parameters={'maxMinutes':75} if i==1 else None)==expected[i],i+1
query=blocks[4]
assert run(query)==[{'id':'c2','title':'Graph Search'}]
run("MATCH (a:Course {id:'c2'}),(b:Course {id:'c4'}) CREATE (a)-[:REQUIRES]->(b);",False)
assert run(query)==[]
run("MATCH (:Course {id:'c2'})-[r:REQUIRES]->(:Course {id:'c4'}) DELETE r;",False)
run("MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}),(c:Course {id:'c2'}) CREATE (m)-[:LIKES_TOPIC]->(t) CREATE (c)-[:ABOUT]->(t);",False)
assert run(query)==[{'id':'c2','title':'Graph Search'},{'id':'c3','title':'Query Patterns'}]
run("MATCH (:Person {id:'maya'})-[r:LIKES_TOPIC]->(:Topic {id:'data'}) DELETE r;",False)
run("MATCH (:Course {id:'c2'})-[r:ABOUT]->(:Topic {id:'data'}) DELETE r;",False)
assert run(query)==[{'id':'c2','title':'Graph Search'}]
# Review counterexamples: malformed inputs must not bypass conservative checks.
run("MATCH (c:Course {id:'c2'}) CREATE (c)-[:REQUIRES]->(:Thing {id:'c9'});",False)
assert run(query)==[]
run("MATCH (:Course {id:'c2'})-[r:REQUIRES]->(x:Thing {id:'c9'}) DELETE r,x;",False)
run("MATCH (c:Course {id:'c2'}) REMOVE c.title;",False)
assert run(query)==[]
run("MATCH (c:Course {id:'c2'}) SET c.title='Graph Search';",False)
run("MATCH (c:Course {id:'c2'}) REMOVE c.id;",False)
assert run(query)==[]
run("MATCH (c:Course {title:'Graph Search'}) SET c.id='c2';",False)
# A title list is one property value, not multiple RDF projected title rows.
run("MATCH (c:Course {id:'c2'}) SET c.title=['Graph Search','Graph Search alternate'];",False)
assert len(run(query))==1
run("MATCH (c:Course {id:'c2'}) SET c.title='Graph Search';",False)
assert run(query)==expected[4]
# Topic classification is not a match condition; learner Person membership is.
run("MATCH (m:Person {id:'maya'}) CREATE (m)-[:LIKES_TOPIC]->(t {id:'viz'}) CREATE (c:Course {id:'c5',title:'Visual Graphs',durationMinutes:30})-[:ABOUT]->(t);",False)
followup=[{'id':'c2','title':'Graph Search'},{'id':'c5','title':'Visual Graphs'}]
assert run(query)==followup
run("MATCH (m:Person {id:'maya'}) REMOVE m:Person;",False)
assert run(query)==[]
run("MATCH (m {id:'maya'}) SET m:Person;",False)
run("MATCH (n) WHERE n.id IN ['c5','viz'] DETACH DELETE n;",False)
assert run(query)==expected[4]
# Execute the three beginner writing-task solutions verbatim.
practice=re.split(r'^// Task \d+\n',(args.lab/'practice_queries.cypher').read_text(),flags=re.M)[1:]
practice_expected=[[{'id':'c3','title':'Query Patterns'}],[{'id':'c1','title':'Graph Basics'}],[{'topic':'graphs','courses':'2'},{'topic':'data','courses':'1'}]]
assert len(practice)==3
for block,wanted in zip(practice,practice_expected):assert run(block)==wanted
# The WITH worked example returns only the topic shared by two courses.
assert run("MATCH (c:Course)-[:ABOUT]->(t:Topic) WITH t, count(DISTINCT c) AS n WHERE n > 1 RETURN t.id AS topic,n ORDER BY topic;")==[{'topic':'graphs','n':'2'}]
# Compare the actual planners on this fixture; no latency claim is inferred.
indexed_plan=run('EXPLAIN '+query,False,output_format='verbose')
unlabeled_plan=run('EXPLAIN '+query.replace("(m:Person {id: 'maya'})","(m {id: 'maya'})"),False,output_format='verbose')
assert 'NodeUniqueIndexSeek' in indexed_plan,indexed_plan
# Store both plans: the optimizer may start at a different selective pattern.
if args.report:
    args.report.with_suffix('.labeled-plan.txt').write_text(indexed_plan)
    args.report.with_suffix('.unlabeled-plan.txt').write_text(unlabeled_plan)
report={'status':'pass','engine':version,'checks':['Loader rerun: 9 nodes, 10 relationships','Published query blocks 1–5 verbatim','maxMinutes=75 parameter','Baseline eligibility','Unmet prerequisite exclusion','Multi-topic DISTINCT result','Untyped prerequisite excludes candidate','Missing title excludes candidate','Missing id excludes candidate','List title: one LPG row, outside scalar contract','Untyped shared topic includes c5','Learner without Person label is excluded','Baseline restored','Labeled EXPLAIN includes NodeUniqueIndexSeek','Three published beginner practice queries','WITH grouping example'],'scope':'Synthetic baseline and named review cases only; title-list case documents non-equivalence outside the contract; not concurrency or production performance.'}
if args.report:args.report.write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
