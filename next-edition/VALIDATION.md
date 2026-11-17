# Unpublished next-edition validation

Executed locally on 16 November 2026. Consolidated review corrections are incorporated;
independent paired reproduction remains open. This is not human peer review,
a benchmark, a suitability assessment or accessibility certification.

## Document and navigation

The PDF has 173 pages, 12 chapter covers and 72 section contents destinations.
Checks cover margins, author and unpublished labels, practice/solution separation,
95 rendered citation numbers, 133 citation annotations and 35 reference entries.
The eight chapter review blocks contain 183 sequential numbered questions, each
with one answer marker in its own question region. Core-question references and
consecutive Review headings are checked. Existing code syntax checks pass (9 Turtle, 1 JSON-LD,
14 SPARQL blocks). Build inputs, PDF and page map are linked by hashes.

Thirteen browser chapter files and the original figure exports are generated from
the same manuscript. Local paths and citation anchors resolve; all 45 code fences
are byte-equivalent to their manuscript counterparts within each chapter.
These are automated guards, together with glossary ordering/duplicate checks,
13 standalone chapter draft notices and 72 section bookmark destinations.
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

Nineteen deliberate defects in temporary package copies are rejected: margin,
missing ordinary label, wrong citation target, invalid SPARQL, broken local link,
missing chapter-cover label at build time, deleted citation annotation, stale
manuscript, altered replay expectation, removed required-value constraint,
invalid mention locator, edited browser output, swapped glossary entries, a
nonexistent core-question reference, a genuinely misplaced answer, a Review
numbering gap, missing chapter draft notice, altered exported code and incorrect
section bookmark destination. No failed probe retains a
stale pass report. See dist/validator-regressions.json. These are structural
guards; they do not establish that an answer is true or a citation supports its claim.

The original lab and research files are byte-identical to the prior reviewed
inputs. Existing Neo4j and OWL DL results are retained historical evidence, not
new execution. The research module retains 145 paired cases: all 143 aligned
cases agree; two boundary counterexamples intentionally differ. These are not
independent paired reproduction results.

## Rebuild comparison and byte identity

CI validates the committed artifacts before rebuilding. It then captures and
compares normalized page text, the page map, outline and selected metadata
(title, author, subject). A local unchanged-source rebuild passed, including byte
equality in that local run; byte equality across environments is not promised.
A reported external byte difference has not been diagnosed. Build metadata records
Python, platform, ReportLab, zlib versions and the fixed SOURCE_DATE_EPOCH.
The default epoch is 16 November 2026 for this draft; it is a reproducibility
setting, not a claim about the actual time a later build ran.

Four changed comparison snapshots (text, page map, outline, metadata) are rejected,
and a byte-different PDF serialization preserving the checked content is accepted.
The reproducible controls and their report are scripts/verify_rebuild.py and
dist/rebuild-controls.json. Text/navigation checks do not establish pixel, layout
or accessibility equivalence. Changed/reflowed PDF pages were also inspected.

## Reproduce the current document checks

From the repository root (the folder containing `REVIEW-START-HERE.md`),
enter `next-edition/` first. If already there, omit the first line:

```sh
cd next-edition
python -m pip install -r requirements-build.txt
python scripts/validate_draft.py
python scripts/check_rebuild.py capture --out /tmp/kg-draft-snapshot.json
python scripts/build_pdf.py
python scripts/export_web.py
python scripts/check_rebuild.py compare --baseline /tmp/kg-draft-snapshot.json --out /tmp/kg-rebuild-comparison.json
python scripts/validate_draft.py
python scripts/verify_draft_validation.py --out /tmp/kg-next-draft-probes
python scripts/verify_rebuild.py --out /tmp/kg-rebuild-probes
```

Use fresh --out destinations throughout. The probe drivers refuse existing output
directories and operate on temporary copies. The snapshot comparison is for
unchanged-source rebuilding: intentional editorial changes may change its result
and must be evaluated separately. Builder/exporter intentionally
regenerate document outputs; retained graph experiment tools retain their own
fresh-destination safeguards. Rebuilding changes output hashes if dependencies
or content differ; do not overwrite archived published releases.
