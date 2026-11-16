# Targeted OWL 2 DL verification

This optional check uses **HermiT 1.3.8.1099**, the standalone JAR bundled in the
pinned Owlready2 0.49 source distribution. It uses the OWL API's OWL2DLProfile
and HermiT's OWLReasoner API. It is not an OWL-RL rules-only check. HermiT is an
OWL 2 DL reasoner; passing these fixtures verifies the named book examples,
not every ontology or every statement in the book.

## Inputs and expected results

The checker constructs the Graduate input from the actual `../ontology.ttl`
and `../catalog.ttl`, adds explicit OWL declarations for their intended class,
object-property, datatype-property, and individual roles, and adds one Person
with no completion as a control. These declarations make the intended mapping
to OWL 2 DL explicit; they are not new completions or altered graduation axioms.
RDF/XML is a serialization accepted by the bundled OWL API. Input copies from
the recorded run are in `fixtures/`; the report contains their hashes.

| Fixture | OWL 2 DL profile | Expected reasoning |
|---|---|---|
| graduate.rdf | Pass | Consistent; Maya and Leo are Graduate; Graduate is satisfiable and a subclass of Person; Graduate is not entailed for the no-completion control |
| contradiction.rdf | Pass | Exercise 5's about/domain/Person/disjointness combination is inconsistent |
| without-disjointness.rdf | Pass | Consistent; Maya is entailed to be a LearningResource |
| without-about.rdf | Pass | Consistent; LearningResource membership for Maya is not entailed |

“Not entailed” is not a negative class assertion. The inconsistency fixture is
not used to make positive claims by entailment: consistency is checked first.

## Run locally

Install the parent lab's pinned Python dependencies and have a JDK 11 or newer
available. The recorded run used Java 21.0.12. From the **lab directory**:

```sh
python3 owl_dl/fetch_hermit.py --output /tmp/kg-hermit
python3 owl_dl/check_owl_dl.py \
  --hermit-jar /tmp/kg-hermit/HermiT.jar \
  --workdir /tmp/kg-owl-inputs --report /tmp/kg-owl-report.json
```

Use new/empty temporary directories. The fetcher downloads only the pinned
source archive, verifies its SHA-256, and extracts the standalone JAR and its
upstream README; it does not install Python packages or Java. The runtime is
not redistributed in this publication package. Keep the upstream notices if
redistributing it separately.

If the host lacks Java, an existing JDK-containing Docker image can supply it:
add `--docker-image IMAGE` to the checker command. The recorded run used the
cached `neo4j:5-community` image solely as a Java runtime, **not** as a database.
The checker overrides the entry point with Java, disables networking, publishes
no ports, and mounts only the reasoner, test source, and fixture directories
read-only. The container is automatically removed after execution. The image
tag is mutable; the report records observed Java and reasoner versions, and the
container image ID for the recorded run is stored with the validation metadata.

## What remains outside this check

This does not test all OWL datatypes, every example in the book, reasoning
performance, a deployed triplestore, or independent execution by another person.
The basic `check_rdf.py` remains a separate RDF/SPARQL/SHACL/RDFS exercise.

## Upstream sources

- [HermiT usage and OWL API integration](https://www.hermit-reasoner.com/using.html)
- [HermiT command-line documentation](https://www.hermit-reasoner.com/command.html)
- [Pinned Owlready2 0.49 distribution](https://pypi.org/project/owlready2/0.49/)
