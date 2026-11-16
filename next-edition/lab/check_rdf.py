import re
from pathlib import Path
from rdflib import Graph, Namespace, RDF, RDFS, Literal
from pyshacl import validate
from owlrl import DeductiveClosure, RDFS_Semantics

ROOT = Path(__file__).resolve().parent
EX = Namespace("https://example.org/")
g = Graph().parse(ROOT / "catalog.ttl", format="turtle")
shapes = Graph().parse(ROOT / "shapes.ttl", format="turtle")
Graph().parse(ROOT / "ontology.ttl", format="turtle")
assert len(set(g.subjects(RDF.type, EX.Course))) == 4
assert len(set(g.subjects(RDF.type, EX.Person))) == 2
assert len(set(g.subjects(RDF.type, EX.Topic))) == 3

def query(name):
    return list(g.query((ROOT / name).read_text()))
assert [str(r.id) for r in query("01_graph_courses.rq")] == ["c1", "c2"]
assert len(query("02_optional_summary.rq")) == 4
assert all(r.summary is None for r in query("02_optional_summary.rq"))
counts = {str(r.topic).split("/")[-1]: int(r.courses)
          for r in query("03_topic_counts.rq")}
assert counts == {"graphs": 2, "data": 1, "ethics": 1}
assert [(str(r.id), str(r.title)) for r in query("04_recommend.rq")] == [
    ("c2", "Graph Search")]
assert [r.required for r in query("05_prerequisites.rq")] == [EX.c1]
assert [str(r.id) for r in query("06_short_courses.rq")] == ["c1", "c3", "c4"]
conforms, _, _ = validate(g, shacl_graph=shapes, inference="none")
assert conforms
# A missing duration must fail the shape.
bad = Graph()
for triple in g: bad.add(triple)
bad.remove((EX.c2, EX.durationMinutes, None))
assert not validate(bad, shacl_graph=shapes, inference="none")[0]
# A second required course not completed by Maya must remove c2.
g.add((EX.c2, EX.requires, EX.c4))
assert query("04_recommend.rq") == []
g.remove((EX.c2, EX.requires, EX.c4))
# Two topics can yield duplicate matches; DISTINCT preserves one course row.
g.add((EX.maya, EX.likesTopic, EX.data))
g.add((EX.c2, EX.about, EX.data))
assert [str(r.id) for r in query("04_recommend.rq")] == ["c2", "c3"]
# Restore the baseline before isolated review counterexamples.
g = Graph().parse(ROOT / "catalog.ttl", format="turtle")
for field in [EX.title,EX.id]:
    values=list(g.objects(EX.c2,field));g.remove((EX.c2,field,None))
    assert query("04_recommend.rq")==[]
    assert not validate(g,shacl_graph=shapes,inference="none")[0]
    for value in values:g.add((EX.c2,field,value))
g.add((EX.c2,EX.requires,EX.c9))
assert query("04_recommend.rq")==[]
assert not validate(g,shacl_graph=shapes,inference="none")[0]
g.remove((EX.c2,EX.requires,EX.c9))
g.add((EX.c2,EX.title,Literal("Graph Search alternate")))
assert len(query("04_recommend.rq"))==2
assert not validate(g,shacl_graph=shapes,inference="none")[0]
g.remove((EX.c2,EX.title,Literal("Graph Search alternate")))
# Class targets include subclass instances in the data graph without inference.
g.add((EX.OnlineCourse,RDFS.subClassOf,EX.Course))
g.add((EX.subclassExample,RDF.type,EX.OnlineCourse))
assert not validate(g,shacl_graph=shapes,inference="none")[0]
g.remove((EX.subclassExample,None,None));g.remove((EX.OnlineCourse,None,None))
assert validate(g,shacl_graph=shapes,inference="none")[0]
# Follow-up equivalence: an untyped shared topic remains a match in both models.
g.add((EX.maya,EX.likesTopic,EX.viz))
for triple in [(EX.c5,RDF.type,EX.Course),(EX.c5,EX.id,Literal("c5")),
               (EX.c5,EX.title,Literal("Visual Graphs")),
               (EX.c5,EX.durationMinutes,Literal(30)),(EX.c5,EX.about,EX.viz)]:g.add(triple)
assert [str(row.id) for row in query("04_recommend.rq")]==["c2","c5"]
assert validate(g,shacl_graph=shapes,inference="none")[0]
g.remove((EX.maya,RDF.type,EX.Person))
assert query("04_recommend.rq")==[]
assert not validate(g,shacl_graph=shapes,inference="none")[0]
g.add((EX.maya,RDF.type,EX.Person))
assert [str(row.id) for row in query("04_recommend.rq")]==["c2","c5"]
g=Graph().parse(ROOT / "catalog.ttl",format="turtle")
# Beginner writing-task solutions execute the published blocks unchanged.
practice=re.split(r'^# Task \d+\n',(ROOT/'practice_queries.rq').read_text(),flags=re.M)[1:]
assert len(practice)==3
assert [(str(r.id),str(r.title)) for r in g.query(practice[0])]==[("c3","Query Patterns")]
assert [(str(r.id),str(r.title)) for r in g.query(practice[1])]==[("c1","Graph Basics")]
assert [(str(r.topic),int(r.courses)) for r in g.query(practice[2])]==[(str(EX.graphs),2),(str(EX.data),1)]
# RDFS classification is tested separately from the baseline dataset.
g.add((EX.Course, RDFS.subClassOf, EX.LearningResource))
DeductiveClosure(RDFS_Semantics).expand(g)
assert (EX.c1, RDF.type, EX.LearningResource) in g
print("PASS: 6 SPARQL queries, baseline and negative SHACL cases, policy changes, malformed-input review cases, subclass targeting, RDFS inference.")
print("OWL: this basic script parses syntax; the separate owl_dl checker executes targeted DL reasoning.")
