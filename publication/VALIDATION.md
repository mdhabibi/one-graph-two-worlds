# Technical validation

This page records the scope of the book's executable examples. It is a test
summary, not a claim of full-book certification or human peer review.

| Area | Recorded checks | Evidence |
|---|---|---|
| RDF and SPARQL | Baseline queries, writing exercises, changed prerequisites, duplicate results, and missing values | lab/check_rdf.py |
| SHACL and RDFS | Positive/negative shapes, learner typing, subclass targeting, and a subclass inference | lab/check_rdf.py |
| Neo4j Community 5.26.30 | Published query blocks, repeatable loading, policy counterexamples, practice queries, WITH, and execution plans | cypher-beginner-validation.json and its plan files |
| OWL 2 DL | Graduate entailments, profile conformance, contradiction and two controls using HermiT 1.3.8.1099 | owl-dl-validation.json; OWL-DL-VERIFICATION.md |
| Reader workflow | Readable runner output, optional filenames, unified container settings, and whole-file loading | runner-followup-validation.json; docker-workflow-validation.json |
| Document and package | Syntax, links, attribution, text bounds, fixture/source hashes, and task/solution page separation | package-validation.json; EDITION-CHECK.json |

Run instructions are in [the lab guide](../lab/README.md) and
[the OWL checker guide](../lab/owl_dl/README.md). Historical JSON reports describe
the earlier query versions named in them. Current execution evidence is identified
above. The repository's Actions tab records actual workflow runs separately.

## Limits

These checks do not establish production performance, concurrency, recovery,
operational security, every OWL example, or formal PDF accessibility conformance.
Further external Neo4j execution and sessions with real beginner readers remain
useful release checks. A successful example run is not proof of real-world data
accuracy. Missing entailment is not a negative assertion.

The book's benchmark discussion and decision scores are illustrative. Graph RAG
pseudocode describes architecture rather than an executed library integration.