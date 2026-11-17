# Missing, optional, untargeted or entailed?

Isolated Section 2.10 exercise. Original code MIT; original text/data CC BY 4.0.
The baseline catalog and its original shapes are unchanged. Use Python 3.10+;
install the pinned [requirements](requirements.txt) into an exercise environment.
From the package root:

```sh
python -m pip install -r extensions/missing-data/requirements.txt
python extensions/missing-data/check_missing_data.py
```

Inspect [data.ttl](data.ttl) and the three shapes before running:
[required](required.ttl), [datatype-only](datatype-only.ttl),
[other target](other-target.ttl). Predict these results:

| Case | Expected |
|---|---|
| c2 explicitly targeted, minCount 1, absent duration | MinCount violation |
| c2 explicitly targeted, datatype-only, absent duration | Conforms to this shapes graph |
| Person-only target, c2 typed only Course | No selected Person; conforms |
| Datatype-only, duration string ninety | Datatype violation on c2/durationMinutes |
| c2 Course, Course subclass LearningResource | LearningResource type absent before RDFS expansion, present afterward |

The first three cases hold data fixed and change shapes/targets. Validation
uses inference none and in-place mutation disabled. The wrong-type control and
RDFS example each use separate graph copies. The script checks focus node,
path and constraint component for violations, and confirms the shared input
remains unchanged. It prints JSON; it does not write files or contact a database.

A datatype-only pass is specific to the selected shapes. The untargeted case is
not evidence that a Course record is complete. RDFS expansion demonstrates one
unstated entailment; it does not run full OWL DL, decide arbitrary negations or
test ontology consistency. The accompanying book explains unresolved propositions
under consistent OWL semantics separately. SHACL does not by itself install
write-time enforcement. Record preprocessing and inference configuration.

Primary reference: [SHACL specification](https://www.w3.org/TR/shacl/).
