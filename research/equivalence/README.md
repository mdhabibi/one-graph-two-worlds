# When do two recommendation queries mean the same thing?

Dr. Mahdi Habibi · Working research companion · 16 November 2026

Read PROTOCOL.md, then derived/RESULTS.md. The 145-case suite includes a complete
128-case bounded grid. This is one query pair, not general graph equivalence.

## Install and run

Use Python 3.10 or later (the retained run records its exact version). From the
extracted package root, create a virtual environment and install:

```sh
python -m pip install -r equivalence/source/requirements.txt -r requirements-report.txt
python equivalence/run_experiment.py --report my-run/rdf.json
```

Use your environment's Python command (on some systems, python3). RDF-only mode
reports Cypher as not run. Paired verification fields remain null; declared
expectations and RDF-side checks are separate from verified cross-engine fields.

Make a Neo4j Community 5.26.x image available locally, then run:

```sh
python equivalence/run_experiment.py --neo4j --image neo4j:5.26.30 --report my-run/paired.json
```

The runner resolves the requested reference to an immutable image ID, verifies
actual Neo4j 5.26.x, creates its own isolated container with no host ports, and
removes it and its anonymous volumes through a cleanup block. It accepts no
existing database. Host termination can interrupt cleanup; remove only the named
kg-equivalence-* instance created by that run. Image tags can change; compare
actual versions, digests and input hashes. No image-pull history is inferred.

## Reproduce summaries, controls and PDF in fresh locations

From the extracted package root:

```sh
python equivalence/verify_revision.py --out my-run/controls
python equivalence/generate_results.py --report my-run/paired.json --out my-run/summary
python build_pdf.py --results my-run/summary/RESULTS.md --report my-run/paired.json --out my-run/document
python check_document.py --pdf my-run/document/Research-Companion-Equivalence.pdf --report my-run/paired.json --out my-run/document-check
```

Use a new destination for each reproduction; tools refuse existing target files
before expensive work. Supplementary corruption simulations replay the retained
paired stdout, not a newly executed graph engine. They are labeled accordingly.
The report generator uses only Python's standard library and support.py; the
PDF tools need requirements-report.txt. Graph runs and controls need the graph
requirements too.

A is query alignment, B is stronger fixture integrity, C is SHACL intake. The
full fixture-state checker is intentionally stricter than the query fragment.
Independent paired reproduction remains open. No performance, production-readiness,
human peer review or personal-suitability claim is made.

Text/data/figures: CC BY 4.0. Original code: MIT. See the root license files and
font notices. Baseline fixtures remain unchanged copies of book version 0.1.1:
https://github.com/mdhabibi/one-graph-two-worlds/releases/tag/v0.1.1
Published book: https://doi.org/10.5281/zenodo.24209667

`python verify_tools.py --out my-run/tools` reproduces the output-refusal,
standard-library summary generation, synthetic metadata and document-margin
controls against the retained package. Its workspace must not already exist.
Synthetic reports and damaged PDF probes stay in that workspace; they are not
new graph-engine evidence. Retained tooling results are in
`equivalence/results/tooling-checks.json`.

Final generator guards can be reproduced with
`python verify_generator_guards.py --out my-run/generator-guards` from the
extracted package root. They use the standard library only; modified reports
are synthetic tooling probes. The retained record is
`equivalence/results/generator-guard-checks.json`.
