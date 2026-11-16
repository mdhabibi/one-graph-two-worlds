"""Run the book's targeted OWL 2 DL checks with a supplied standalone HermiT JAR.
Requires the lab's rdflib; a JDK 11+ (source-file launcher) or --docker-image.
No Java runtime or reasoner is installed by this script.
"""
from pathlib import Path
import argparse, hashlib, json, subprocess, tempfile, zipfile
from rdflib import Graph, Namespace, RDF, OWL, RDFS
P=argparse.ArgumentParser(description=__doc__)
P.add_argument('--hermit-jar',required=True,type=Path)
P.add_argument('--java',default='java')
P.add_argument('--docker-image',help='Existing image containing a JDK; network disabled')
P.add_argument('--workdir',type=Path,help='New/empty directory to retain generated inputs')
P.add_argument('--report',type=Path)
a=P.parse_args();lab=Path(__file__).resolve().parents[1];jar=a.hermit_jar.resolve()
EX=Namespace('https://example.org/')
def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def declare(g,term,kind):g.add((term,RDF.type,kind))
def build_inputs(folder):
 g=Graph().parse(lab/'ontology.ttl')
 for triple in Graph().parse(lab/'catalog.ttl'):g.add(triple)
 for name in ['Course','Person','Topic']:declare(g,EX[name],OWL.Class)
 for name in ['completed','likesTopic','about','requires']:declare(g,EX[name],OWL.ObjectProperty)
 for name in ['id','name','title','durationMinutes']:declare(g,EX[name],OWL.DatatypeProperty)
 for term in list(g.subjects(RDF.type,EX.Person))+list(g.subjects(RDF.type,EX.Course))+list(g.subjects(RDF.type,EX.Topic)):
  declare(g,term,OWL.NamedIndividual)
 declare(g,EX.noCompletion,OWL.NamedIndividual);g.add((EX.noCompletion,RDF.type,EX.Person))
 g.serialize(folder/'graduate.rdf',format='xml')
 c=Graph()
 for term in [EX.Person,EX.LearningResource,EX.Topic]:declare(c,term,OWL.Class)
 declare(c,EX.about,OWL.ObjectProperty)
 for term in [EX.maya,EX.graphs]:declare(c,term,OWL.NamedIndividual)
 c.add((EX.about,RDFS.domain,EX.LearningResource));c.add((EX.about,RDFS.range,EX.Topic))
 c.add((EX.Person,OWL.disjointWith,EX.LearningResource))
 c.add((EX.maya,RDF.type,EX.Person));c.add((EX.maya,EX.about,EX.graphs))
 c.serialize(folder/'contradiction.rdf',format='xml')
 c.remove((EX.Person,OWL.disjointWith,EX.LearningResource))
 c.serialize(folder/'without-disjointness.rdf',format='xml')
 c.add((EX.Person,OWL.disjointWith,EX.LearningResource));c.remove((EX.maya,EX.about,EX.graphs))
 c.serialize(folder/'without-about.rdf',format='xml')
with tempfile.TemporaryDirectory() as temp:
 folder=a.workdir.resolve() if a.workdir else Path(temp)/'inputs'
 folder.mkdir(parents=True,exist_ok=True)
 assert not any(folder.iterdir()),'Use a new/empty --workdir; existing inputs are not overwritten.'
 build_inputs(folder)
 source=Path(__file__).with_name('CheckOwlDl.java').resolve()
 if a.docker_image:
  cmd=['docker','run','--rm','--network','none','--memory','1g','--entrypoint','java',
       '-v',str(jar.parent)+':/reasoner:ro','-v',str(source.parent)+':/checks:ro',
       '-v',str(folder)+':/inputs:ro',a.docker_image,'-Xmx512m','-cp',
       '/reasoner/'+jar.name,'/checks/CheckOwlDl.java','/inputs']
 else:cmd=[a.java,'-Xmx512m','-cp',str(jar),str(source),str(folder)]
 run=subprocess.run(cmd,capture_output=True,text=True,timeout=180)
 if run.returncode:raise RuntimeError(run.stdout+'\n'+run.stderr)
 assert 'PASS: OWL 2 DL profiles' in run.stdout
 java=next(x.split('=',1)[1] for x in run.stdout.splitlines() if x.startswith('JAVA='))
 version=next(x.split('=',1)[1] for x in run.stdout.splitlines() if x.startswith('HERMIT='))
 report={'status':'pass','reasoner':'HermiT','reasoner_version':version,'java_version':java,
  'hermit_jar_sha256':digest(jar),'sources':{f.name:digest(f) for f in [lab/'ontology.ttl',lab/'catalog.ttl',source,Path(__file__).resolve(),source.with_name('fetch_hermit.py')]},
  'generated_input_sha256':{f.name:digest(f) for f in sorted(folder.glob('*.rdf'))},
  'docker_image':a.docker_image,'stdout':run.stdout,'stderr':run.stderr,
  'scope':'Targeted OWL 2 DL profile, consistency and entailment checks for the Graduate example and Exercise 5, with counterfactual controls; not a verification of every OWL example, production system, or independent execution.'}
 if a.report:a.report.write_text(json.dumps(report,indent=2)+'\n')
 print(json.dumps(report,indent=2))
