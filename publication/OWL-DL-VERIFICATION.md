# Targeted OWL 2 DL verification — completed

HermiT **1.3.8.1099**, running on **Java 21.0.12**, passed the requested checks for
the Graduate definition and the contradictory-classification exercise. This is
an actual DL reasoner execution, separate from the basic RDF/OWL-RL checks.

| Case | Profile check | Reasoner result |
|---|---|---|
| Graduate ontology with baseline catalog and explicit declarations | OWL 2 DL: pass | Consistent; Maya and Leo are Graduate |
| Person control with no completion | Same input/profile | Graduate membership is not entailed |
| Graduate class | Same input/profile | Satisfiable and a subclass of Person |
| Exercise 5: domain-induced type plus disjointness | OWL 2 DL: pass | Inconsistent, as expected |
| Remove only the disjointness axiom | OWL 2 DL: pass | Consistent; Maya is a LearningResource |
| Remove only Maya's about assertion | OWL 2 DL: pass | Consistent; Maya's LearningResource membership is not entailed |

The test checks consistency before asking for positive entailments. A missing
entailment is not treated as a negative class assertion. The controls show that
the intended contradiction depends on the relevant facts and axioms together.

## Reproduction and evidence

- `lab/owl_dl/CheckOwlDl.java`: OWL API profile checks and HermiT assertions.
- `lab/owl_dl/check_owl_dl.py`: builds inputs from the actual lab ontology/catalog
  and executes the checker with a supplied JAR and JDK or Docker runtime.
- `lab/owl_dl/fetch_hermit.py`: downloads a pinned Owlready2 0.49 source archive,
  verifies archive and JAR SHA-256, and saves the upstream notice with the JAR.
- `lab/owl_dl/fixtures/`: exact serialized inputs from the recorded final run.
- `publication/owl-dl-validation.json`: versions, source/input/runtime hashes,
  observed results, stdout, and limits.

The packaged fetcher and checker were executed end-to-end. The same results
were first obtained with the extracted bundle, then reproduced with the fetcher.
Generated RDF/XML blank-node labels and statement order may differ between runs;
compare graphs semantically rather than expecting regeneration to preserve bytes.
The report hashes identify the exact retained inputs, not a claim of canonical RDF.

The Graduate fixture adds explicit OWL declarations for intended class/property
roles from the book, and a no-completion Person as a control. These are documented
in the lab README. No graduation axiom or baseline completion was replaced.

## Runtime and remaining limits

The host had no Java installation, so the cached image identified in the report
supplied Java only. No Neo4j database server was started for these checks. The
containers had networking disabled, no published ports, and read-only mounts;
`--rm` removed them after execution. The reasoner binary is not redistributed
inside this publication package.

This closes the requested targeted full-DL-engine checks. It does not establish
correctness of every OWL example or production workload. Independent Neo4j
execution, a GitHub Actions run, and sessions with real beginner readers remain
external checks. Nothing has been published by this task.

Upstream: [HermiT usage](https://www.hermit-reasoner.com/using.html),
[HermiT CLI](https://www.hermit-reasoner.com/command.html),
[pinned distribution](https://pypi.org/project/owlready2/0.49/).
