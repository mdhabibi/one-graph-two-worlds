# Observed results

**Actual paired execution · RDFLib and Neo4j · Working module**

The retained run used Python 3.12.14, RDFLib 7.1.4, pySHACL 0.30.1, owlrl 7.1.4, and Neo4j 5.26.30 community.

The requested image reference was `sha256:07ae69e32057621c2a896b9e1e80fc13a51928aa6aecab08d0cdec92d2bf5d56`. The runner resolved it to the immutable image ID retained in the report before launching. These fields do not establish when the image was pulled.

## Summary

| Observation | Actual result |
|---|---|
| Paired datasets | 145 |
| Query alignment A | 143; all results equal |
| Fixture integrity B | 139 |
| SHACL intake C | 140 |
| Generated grid | 128; all matched the separately expressed set predicate |
| Equal recommendation sets | 143 |
| Required boundary disagreements | 2 |
| Parallel completion count | RDF 1; LPG 2 |
| Explicit completion-event count | RDF 2; LPG 2 |

These are constructed datasets, not a statistical success rate. A tests the query-relevant mapping. B combines stricter fixture rules with full projected-state equality. C is validation against the unchanged SHACL shapes. They are different judgments.

## Curated observations

| Case | Aligned A | Integrity B | SHACL C | Results |
|---|---|---|---|---|
| C01-baseline | yes | pass | pass | equal |
| C02-unmet-prerequisite | yes | pass | pass | equal |
| C03-already-completed | yes | pass | pass | equal |
| C04-two-matching-topics | yes | pass | pass | equal |
| C05-untyped-topic | yes | pass | pass | equal |
| C06-missing-title | yes | fail | fail | equal |
| C07-untyped-learner | yes | fail | fail | equal |
| C08-non-Course-prerequisite | yes | fail | fail | equal |
| C09-self-prerequisite | yes | pass | pass | equal |
| C10-direct-not-transitive-policy | yes | pass | pass | equal |
| C11-missing-id | yes | fail | fail | equal |
| B01-multivalued-title | no | fail | fail | different |
| B02-parallel-completions | yes | pass | pass | equal |
| B03-asymmetric-inference | no | fail | pass | different |
| B04-explicit-completion-events | yes | pass | pass | equal |
| C12-all-multiple-prerequisites-completed | yes | pass | pass | equal |
| C13-aligned-membership-control | yes | pass | pass | equal |

C06, C07, C08 and C11 satisfy query alignment, but fail fixture rules and SHACL intake. Their empty-result agreement is covered by the broadened conditional argument. The earlier stronger sufficient contract excluded them; that exclusion was not a counterexample to it.

## Inspect the boundary cases

### B01-multivalued-title

RDF has two scalar title bindings; this LPG representation returns one list value.

RDF: `[["c2", "Alternate title"], ["c2", "Graph Search"]]`

Cypher: `[["c2", ["Graph Search", "Alternate title"]]]`

### B03-asymmetric-inference

RDFS materialization adds Course on RDF side; LPG lacks aligned Course label.

RDF: `[["c2", "Graph Search"]]`

Cypher: `[]`

## Supplementary controls

See equivalence/results/revision-checks.json for separately executed supplementary controls and their exact scope. Simulated engine output is distinct from actual engine execution; this summary does not infer a control count from the paired report.

## Interpretation and limits

The two intentional disagreements were observed. Parallel completions preserve this existence-based answer while losing count equivalence; explicit event identities preserve two occurrences in the repair example.

This is one synthetic catalog, a bounded 128-case grid, one SPARQL implementation, one LPG engine and one authoring environment. It does not establish arbitrary RDF/LPG equivalence, performance, business completeness, GraphRAG answer quality, personal suitability or production readiness. Independent paired reproduction remains open; this is not human peer review.

## Retained evidence

All paths below are relative to the extracted package root.

- `equivalence/results/paired-run.json`: typed answers, states, classifications, runtime identity and input hashes.
- `equivalence/results/paired-run.cypher` and `equivalence/results/paired-run.stdout.txt`: exact script and raw engine output.
- `equivalence/results/revision-checks.json`: supplementary checks and simulations.
- `equivalence/results/tooling-checks.json`: tooling regression outcomes and tool hashes.
- `equivalence/results/generator-guard-checks.json`: generator input-guard regressions.
- `equivalence/results/document-check.json`: PDF/report hashes, margins, text and links.
- `equivalence/derived/RESULTS.md` and `equivalence/derived/observations.csv`: generated summaries.
- `equivalence/run_experiment.py`, `equivalence/source/`, `equivalence/support.py`: experiment inputs.
- `equivalence/generate_results.py`, `equivalence/verify_revision.py`: summary and supplementary-control tools.
- `verify_tools.py`, `verify_generator_guards.py`: tooling and generator regression drivers.
- `build_pdf.py`: PDF builder; `check_document.py`: document-evidence checker.

The report retains full image ID, digests, architecture and OS. The disposable container exposed no host ports and used no existing database.
