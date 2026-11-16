# Knowledge Graphs — next-edition working draft

Dr. Mahdi Habibi · 16 November 2026 · Unpublished

This private working package integrates the reviewed query-equivalence material
into three new Chapter 10 sections. The 0.1.1 baseline queries and fixtures are
unchanged. All five queued reader-feedback additions are integrated across the manuscript,
Q&A, glossary, navigation and relevant companion exercises. Consolidated technical
review remains pending.
No edition number or DOI is assigned to this draft. Published 0.1.1 and its
archived artifacts remain unchanged.

Read `dist/knowledge-graphs-tutorial.pdf` or edit `book/manuscript.md`.
The full protocol, source and retained experiment evidence are in `research/`.
Read `research/equivalence/README.md` for fresh-path experiment reproduction.
Retained paired results use one project environment. All 143 query-aligned
cases agree; the two boundary counterexamples intentionally differ. No independent
paired reproduction, human peer review, benchmark or production certification
is claimed.

To rebuild the full draft from this root:

```sh
python -m pip install -r requirements-build.txt
python scripts/build_pdf.py
python scripts/export_web.py
python scripts/validate_draft.py
```

The book builder intentionally rebuilds draft PDF/metadata outputs. Research
evidence tools instead require fresh output destinations and refuse overwrites.
Original text/figures/data use CC BY 4.0, original code MIT; bundled fonts retain
their notices. See the license files. The prior source edition can be cited via
https://doi.org/10.5281/zenodo.24228810; that DOI does not identify this draft.

The integrated revision reconciles Sections 4.6 and 10.3, labels every page as an
unpublished working draft, and checks margins, authorship, chapter covers, the destinations of all
contents and citation links, coverage of rendered citations, build-input hashes, three practice/solution pairs, RDF/SPARQL
syntax, local links and retained research hashes. `scripts/verify_draft_validation.py`
can reproduce deliberate-defect checks with `--out` pointing to a fresh directory.
Browser-readable chapters and original figures are generated from the same source.

See [the semantic-evolution exercise](extensions/semantic-evolution/README.md)
for the isolated mapping and effective-policy extension. Run its checker with
`python extensions/semantic-evolution/check_evolution.py`.

## New isolated exercises and worksheets

- [Semantic evolution](extensions/semantic-evolution/README.md): mapping and dated policy replay.
- [Identity and evidence](extensions/identity-evidence/README.md): alias/edition controls and source retention.
- [Missing data](extensions/missing-data/README.md): actual SHACL variations and a separate RDFS consequence.
- [Reasoning decision](extensions/reasoning-decision/README.md): workload worksheet; no new performance claim.
- [Suitability scope](extensions/suitability-scope/README.md): claim/evidence discussion; no validated assessment instrument.

Rebuild the browser chapters with `python scripts/export_web.py` after building
the PDF. Read [book/index.md](book/index.md) for chapter navigation.
All extensions are separate from the original lab and retained research evidence.
