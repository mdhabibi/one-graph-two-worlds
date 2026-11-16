# Unpublished next-edition validation

Executed locally on 16 November 2026. Consolidated technical review and
independent paired reproduction remain pending. This is not human peer review,
a benchmark, a suitability assessment or accessibility certification.

## Document and navigation

The PDF has 173 pages, 12 chapter covers and 72 section contents destinations.
Checks cover margins, author and unpublished labels, practice/solution separation,
95 rendered citation numbers, 133 citation annotations and 35 reference entries.
The eight chapter review blocks contain 183 sequential numbered questions, each
with an explained answer. Existing code syntax checks pass (9 Turtle, 1 JSON-LD,
14 SPARQL blocks). Build inputs, PDF and page map are linked by hashes.

Thirteen browser chapter files and the original figure exports are generated from
the same manuscript. Local paths and citation anchors resolve; all 45 code fences
are byte-equivalent to their manuscript counterparts. Glossary ordering was checked.
Changed and reflowed pages were visually inspected. This is not PDF/UA validation.

## Isolated extensions

- Semantic evolution: 10 checks, including dated replay, threshold boundaries,
  missing score, ambiguous policy interval and semantic substitution rejection.
- Identity/evidence: 8 checks covering aliases, different editions, unresolved
  identity, retained locators, unchanged claim-review status and invalid locators.
- Missing data: four actual SHACL cases and one separate RDFS consequence;
  observed constraint components, focus node and path checked on violations.
- Reasoning cost and personal suitability use worksheets. No new performance
  experiment or empirically validated suitability instrument is claimed.

The build requirements pin RDFLib 7.1.4, pySHACL 0.30.1 and owlrl 7.1.4. The
standalone extension tools print JSON without changing the baseline or writing
outputs. Recorded reports identify input hashes. See each extension's README
for its dependency and interpretation limits.

## Negative controls and unchanged evidence

Twelve deliberate defects in temporary package copies are rejected: margin,
missing ordinary label, wrong citation target, invalid SPARQL, broken local link,
missing chapter-cover label at build time, deleted citation annotation, stale
manuscript, altered replay expectation, removed required-value constraint,
invalid mention locator and edited browser output. No failed probe retains a
stale pass report. See dist/validator-regressions.json.

The original lab and research files are byte-identical to the prior reviewed
inputs. Existing Neo4j and OWL DL results are retained historical evidence, not
new execution. The research module retains 145 paired cases: all 143 aligned
cases agree; two boundary counterexamples intentionally differ. These are not
independent paired reproduction results.

## Reproduce the current document checks

From this package root:

```sh
python -m pip install -r requirements-build.txt
python scripts/build_pdf.py
python scripts/export_web.py
python scripts/validate_draft.py
python scripts/verify_draft_validation.py --out /tmp/kg-next-draft-probes
```

Use a fresh --out destination for the last command. It refuses existing output
directories and runs probes in temporary copies. Builder/exporter intentionally
regenerate document outputs; retained graph experiment tools retain their own
fresh-destination safeguards. Rebuilding changes output hashes if dependencies
or content differ; do not overwrite archived published releases.
