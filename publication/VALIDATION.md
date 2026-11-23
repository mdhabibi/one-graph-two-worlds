# Technical validation — version 0.2.1

This page describes the scope of automated checks and retained experiments. It
is not human peer review, production certification or a suitability assessment.
The edition DOI is 10.5281/zenodo.24483542; publication status is recorded in
[the release checklist](RELEASE-CHECKLIST.md).

## Current book and package

This published 0.2.1 edition improves illustrations with unchanged baseline lab and
research inputs. Zenodo publication and both uploaded file checksums were verified.
Current execution summary is [release-validation.json](release-validation.json).
SVG editing inputs are kept separate from generated exports. The new diagram
scenarios and counterfactual were checked during illustration preparation;
these checks are not independent human review or a reader study.


The checked source contains 183 numbered review questions and answers across
eight chapter review blocks, 75 glossary entries and 82 core-question references.
The generated PDF's actual page count, practice/solution locations and hash are
recorded in `publication/EDITION-CHECK.json` and
`publication/package-validation.json`. The renderer records its inputs
and environment in [build-inputs.json](../dist/build-inputs.json).

Checks cover 12 chapter covers, 72 contents/section bookmark destinations,
author and public-review labels, margins, citation destinations and rendered
citation coverage, reference anchors, Q&A placement, sequential Review headings,
glossary order, local paths and RDF/SPARQL syntax. Thirteen browser chapters are
exported from the same source; all 45 code fences are checked against it.
Structural checks do not judge whether an answer is true or a citation supports
its claim. Chapter 9's guided exercises use a separate answer format and are
outside the numbered-Q&A guard.

## Exercises and retained graph evidence

- [Semantic evolution](../extensions/semantic-evolution/README.md): ten checks,
  including dated replay, boundaries, missing evidence and incompatible meaning.
- [Identity/evidence](../extensions/identity-evidence/README.md): eight checks
  covering aliases, different editions, retained locators and unresolved identity.
- [Missing data](../extensions/missing-data/README.md): four actual SHACL cases
  and one separate RDFS consequence, with violation details checked.
- Reasoning cost and personal suitability use discussion worksheets, not a new
  benchmark or an empirically validated assessment instrument.
- [Baseline RDF lab](../lab/README.md): queries, policy variations, SHACL and RDFS.
- Historical Neo4j Community 5.26.30 and HermiT OWL 2 DL checks are retained in
  this folder against unchanged lab inputs; see [the OWL report](owl-dl-validation.json).
  Historical results remain unchanged. Fresh version 0.2.0 baseline Neo4j and
  targeted HermiT runs are recorded separately in
  [the release validation summary](release-validation.json),
  [Cypher checks](cypher-0.2.0-validation.json) and
  [OWL checks](owl-0.2.0-validation.json). They are local runs, not independent reproduction.
- [Equivalence research](../research/equivalence/README.md): retained results from
  145 controlled cases, with agreement in 143 aligned cases and two intentional
  boundary counterexamples. Independent paired reproduction remains open.

The research directory is a byte-preserved companion snapshot from 16 November
2026. Its working-module labels, earlier review notes, source-edition references
and original environment records describe that snapshot, not the current book's
publication status. The separate research PDF is not the version 0.2.0 book.
The root lab fixtures and research files remain unchanged from the reviewed inputs.

## Rebuild comparison and controls

CI first validates committed artifacts, captures normalized per-page text, page
map, outline and selected metadata, then rebuilds/exports and compares. Byte
equality across environments is not promised. A prior external build matched
those content/navigation checks with different PDF bytes; the cause has not been
established. These comparisons do not establish pixel or accessibility equality.

The fixed SOURCE_DATE_EPOCH for version 0.2.0 is 17 November 2026; it is a build
setting, not an assertion of publication time. Build records include Python,
platform, ReportLab and compile/runtime zlib versions.

The release probe driver rejects 23 deliberate document, extension, metadata
and DOI-hyperlink defects in temporary copies and requires failure without a stale pass report.
The rebuild driver tests four changed comparison snapshots and one different
PDF serialization preserving the checked content. Fresh results identify the
validator/driver/input hashes. See `dist/validator-regressions.json`,
`dist/rebuild-controls.json` and
`dist/rebuild-comparison.json`.

## Reproduce

Run from the repository root (the folder containing `VERSION` and `README.md`).
Use the same Python environment throughout, with pinned dependencies:

```sh
python -m pip install -r requirements-build.txt -r lab/requirements.txt
python scripts/check_package.py
python scripts/check_rebuild.py capture --out /tmp/kg-021-snapshot.json
python scripts/build_pdf.py
python scripts/export_web.py
python scripts/check_rebuild.py compare --baseline /tmp/kg-021-snapshot.json --out /tmp/kg-021-comparison.json
python scripts/check_package.py
python lab/check_rdf.py
python scripts/verify_release_validation.py --out /tmp/kg-021-validation-probes
python scripts/verify_rebuild.py --out /tmp/kg-021-rebuild-probes
```

Use fresh `--out` destinations; probe drivers refuse existing output directories.
The builder/exporter regenerate document outputs; experiments have their own
fresh-path safeguards. Never overwrite an archived published release. Check
[the release checklist](RELEASE-CHECKLIST.md) for this candidate's actual run status;
a workflow file or older successful run does not establish current remote CI success.

## Limits

No general RDF/LPG equivalence, performance superiority, real-world data accuracy,
personal suitability, production reliability or PDF/UA conformance is established.
Graph RAG pseudocode illustrates architecture rather than an executed integration.
Missing entailment is not a negative assertion. Remote CI and publication must be
observed separately from local checks.
