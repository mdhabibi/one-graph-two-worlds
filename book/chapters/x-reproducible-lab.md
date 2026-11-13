# X · Reproducible lab

## 10.1 Files, versions, and execution boundaries

We now move from reading examples to reproducing them. This section identifies the complete lab files and separates checks you can run locally from behaviors that require a configured database or reasoning engine. Begin with a clean baseline before trying any model extension.

### The companion lab
The downloadable lab contains the baseline RDF catalog, SHACL shapes, an OWL example, SPARQL queries, a full Cypher loader and query set, and a small RDF checker. A README lists commands and expected answers. The examples are synthetic and intended for a dedicated exercise environment.

### RDF route
Create a local Python environment and install the pinned dependencies listed in the lab. Run the checker to parse the graphs, execute the baseline queries, and evaluate the shapes. The checker also injects a missing-duration defect to verify that validation reports it. The basic RDF checker parses the OWL example but does not execute a DL reasoner. A separate optional checker in lab/owl_dl uses HermiT, a complete OWL 2 DL reasoner, for the Graduate definition and the contradictory-classification exercise. In the recorded run, all four input fixtures passed the OWL 2 DL profile check; Maya and Leo were classified as Graduate, the disjointness example was inconsistent, and the two counterfactual controls behaved as expected. The companion report records versions, input hashes, and limits. This is targeted verification of those examples, not a claim that every OWL example or production deployment has been tested.

**Local lab commands — create an environment and run the checker.** Run these from the extracted lab directory. They install the listed Python libraries and execute check_rdf.py; they do not start a Neo4j server.

```text
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python check_rdf.py
```

The checker prints a concise result and exits with failure if an expected result changes. This is a learning fixture, not a performance test. A local RDF library does not demonstrate triplestore behavior under concurrent updates or large datasets.

### Neo4j route
Use a dedicated exercise database with a Neo4j 5-compatible Cypher environment. Execute the full loader from the companion files, then the provided read queries. Statements use semicolon separators. Query tools differ in whether they accept a whole script or require one statement at a time. Validate four courses, two people, three topics, and recommendation result c2.

The lab includes a Docker-based checker for an empty, dedicated database. Its baseline and named policy cases were executed against Neo4j Community 5.26.30 on 13 November 2026. The validation report records the scope and observed results; the checker does not install a production server. A successful fixture check is not a test of concurrent writes, recovery, or production performance. Newer releases may introduce schema and path features beyond this baseline. [[2](xii-references.md#ref2), [6](xii-references.md#ref6), [7](xii-references.md#ref7)]

### Keep the experiment honest
Do not combine extension snippets with the baseline and expect unchanged counts. The event, named-graph, provenance, and Graph RAG examples illustrate later modeling choices. Treat each extension as a controlled migration, update the expected answers, and retain the original fixture for comparison.

## 10.2 Expected outputs and extension checklist

After loading the baseline, compare your results with the table below. These values describe the unchanged starting catalog. The later checklist proposes separate extensions; each requires a deliberate model and test update rather than an unexplained change to the expected answers.

| Check | Expected baseline result |
|---|---|
| Explicit Course instances | 4 |
| Explicit Person instances | 2 |
| Topic entities | 3 |
| Courses about Graphs | c1, c2 |
| Courses lasting at most 75 minutes | c1, c3, c4 |
| Prerequisite reachable from c2 | c1 |
| Distinct courses by topic | RDF: ex:graphs 2, ex:data 1, ex:ethics 1 (expanded IRIs); Cypher: graphs 2, data 1, ethics 1 |
| Maya's eligible recommendation | c2 / Graph Search |
| CourseShape on baseline | Conforms |
| CourseShape after removing c2 duration | Does not conform |

### Add one requirement at a time
**Multilingual catalog:** change title modeling and shapes to accept language-tagged values, then define preferred-language fallback. Preserve both languages in any RDF/LPG mapping.

**Course editions:** introduce offering or edition IDs. Define whether completion of one edition satisfies a prerequisite for another. Update evidence and migration rules.

**Temporal eligibility:** add event time, expiration, and policy time. Distinguish a fact's real-world validity from when the system learned it. Query eligibility as of a declared time.

**Prerequisite alternatives:** represent “c1 OR an equivalent assessment” as an explicit requirement group rather than adding two simple REQUIRES edges, which the current policy interprets conjunctively. The model and query must change together.

**Course retirement:** add lifecycle state and ensure eligibility filters it. Keep historical references valid for past completions and audit records.

**Evidence-aware answers:** require a reviewed source and locator for each user-facing claim. Add negative test cases where the source is absent, stale, or inaccessible. The correct answer can be abstention rather than a guess.

> When a requirement changes, revisit the conceptual model, acceptance rules, query semantics, and expected outputs together. A field added to storage is only one part of the change.

