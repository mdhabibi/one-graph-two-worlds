"""Execute isolated SHACL absence controls and an RDFS entailment example."""
import hashlib
import importlib.metadata
import json
from pathlib import Path
from rdflib import Graph, Namespace, RDF, RDFS, Literal, XSD
from pyshacl import validate
from owlrl import DeductiveClosure, RDFS_Semantics
ROOT = Path(__file__).resolve().parent
EX = Namespace('https://example.org/')
SH = Namespace('http://www.w3.org/ns/shacl#')

def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)

def main():
    baseline = Graph().parse(ROOT / 'data.ttl')
    expected_data = set(baseline)
    require(expected_data == {(EX.c2, RDF.type, EX.Course)}, 'Absence fixture changed')
    observations = []
    def case(name, shape, data, conforms, component=None):
        actual, report, _ = validate(data, shacl_graph=Graph().parse(ROOT / shape), inference='none', inplace=False)
        require(bool(actual) == conforms, 'Unexpected conformance: ' + name)
        results = list(report.subjects(RDF.type, SH.ValidationResult))
        components = sorted({str(value) for result in results for value in report.objects(result, SH.sourceConstraintComponent)})
        if component is not None:
            require(components == [str(component)], 'Unexpected component: ' + name)
            require({value for result in results for value in report.objects(result, SH.focusNode)} == {EX.c2}, 'Unexpected focus node')
            require({value for result in results for value in report.objects(result, SH.resultPath)} == {EX.durationMinutes}, 'Unexpected result path')
        else:
            require(not results, 'Unexpected SHACL results: ' + name)
        observations.append({'case': name, 'conforms': bool(actual), 'results': len(results), 'components': components})
    case('required-missing', 'required.ttl', baseline, False, SH.MinCountConstraintComponent)
    case('datatype-only-missing', 'datatype-only.ttl', baseline, True)
    case('different-target-class', 'other-target.ttl', baseline, True)
    require(set(baseline) == expected_data, 'Validation mutated shared data')
    wrong = Graph()
    for triple in baseline:
        wrong.add(triple)
    wrong.add((EX.c2, EX.durationMinutes, Literal('ninety', datatype=XSD.string)))
    case('datatype-only-wrong-type', 'datatype-only.ttl', wrong, False, SH.DatatypeConstraintComponent)
    inference_graph = Graph()
    for triple in baseline:
        inference_graph.add(triple)
    inference_graph.add((EX.Course, RDFS.subClassOf, EX.LearningResource))
    conclusion = (EX.c2, RDF.type, EX.LearningResource)
    require(conclusion not in inference_graph, 'Conclusion already explicitly asserted')
    DeductiveClosure(RDFS_Semantics).expand(inference_graph)
    require(conclusion in inference_graph, 'RDFS subclass consequence missing')
    require(set(baseline) == expected_data, 'Inference changed shared absence fixture')
    observations.append({'case': 'unstated-but-rdfs-entailed', 'explicit_before': False, 'entailed_after': True})
    files = [Path(__file__), ROOT/'data.ttl', ROOT/'required.ttl', ROOT/'datatype-only.ttl', ROOT/'other-target.ttl', ROOT/'requirements.txt']
    print(json.dumps({'status': 'pass', 'observations': observations,
                      'versions': {name: importlib.metadata.version(name) for name in ['rdflib', 'pyshacl', 'owlrl']},
                      'inputs': {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in files},
                      'scope': 'Four SHACL cases, inference none, and one separate RDFS closure. No OWL DL consistency check, negative-entailment decision, write enforcement or production assessment.'}, indent=2))
if __name__ == '__main__':
    main()
