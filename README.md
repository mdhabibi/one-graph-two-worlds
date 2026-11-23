<h1 align="center">Knowledge Graphs:<br>Semantic Graphs and Property Graphs</h1>

<p align="center">
  <strong>Dr. Mahdi Habibi</strong><br>
  Version 0.2.1 · Public review draft
</p>

<p align="center">
  <a href="dist/knowledge-graphs-tutorial.pdf">
    <img src="assets/figures/cover.png" alt="Knowledge Graphs: Semantic Graphs and Property Graphs — Dr. Mahdi Habibi" width="560">
  </a>
</p>

<p align="center">
  <strong>One catalog. Two graph worlds.</strong><br>
  An illustrated, hands-on path from graph fundamentals to architecture and graph RAG.
</p>

<p align="center">
  <a href="https://zenodo.org/records/24483542"><strong>Edition DOI</strong></a> ·
  <a href="dist/knowledge-graphs-tutorial.pdf">Read the PDF</a> ·
  <a href="book/index.md">Browse the chapters</a> ·
  <a href="lab/README.md">Explore the lab</a> ·
  <a href="publication/VALIDATION.md">Validation evidence</a>
</p>

A practical learning path through RDF, RDFS, OWL, SPARQL, SHACL, labeled property
graphs, Neo4j, and Cypher, using one synthetic course-recommendation catalog.
Later parts cover event modeling, provenance, interoperability, architecture,
operations, graph RAG, and analytics.

## Start reading

- [Book PDF](dist/knowledge-graphs-tutorial.pdf)
- [Read the chapters in a browser](book/index.md)
- [Run the companion lab](lab/README.md)
- [See the actual validation results](publication/VALIDATION.md)

The intended audience begins with graph concepts. New terms are introduced by
the question they answer. Baseline data, isolated variations, model extensions,
and pseudocode are labeled separately. Each technical part has learning goals
and a short self-check.

## Edition status

Version **0.2.1** was published on Zenodo on **23 November 2026** as an illustrated public review revision.
Edition DOI: [10.5281/zenodo.24483542](https://doi.org/10.5281/zenodo.24483542)
The repository PDF and browser
chapters describe the same source. The archived companion ZIP is the pre-publication snapshot; this repository adds verified
publication links and citation dates. The PDF is byte-identical to the archive.
Publication status is recorded in
[the release checklist](publication/RELEASE-CHECKLIST.md).

This 179-page revision includes 18 figures, 183 explained review questions and
75 glossary entries. It improves visual explanations, recommendation bindings, validation
targets, semantic evolution, event evidence and hybrid reconciliation. It keeps
the existing baseline fixtures, query listings and retained research unchanged.
Editable SVG inputs are in `assets/figure-sources/`; generated exports are separate.

The published [0.2.0 archive](https://zenodo.org/records/24316420),
[0.1.1 archive](https://zenodo.org/records/24228810) and
[0.1.0 archive](https://zenodo.org/records/24209668) remain unchanged under their
own DOIs. Cite the exact edition you use.

## Explore the additions

- [Recommendation equivalence: protocol and retained results](research/equivalence/README.md)
- [Semantic evolution and dated policy replay](extensions/semantic-evolution/README.md)
- [Entity identity and source evidence](extensions/identity-evidence/README.md)
- [SHACL missing-data cases and an RDFS consequence](extensions/missing-data/README.md)
- [Reasoning-cost decision worksheet](extensions/reasoning-decision/README.md)
- [Eligibility, suitability and abstention worksheet](extensions/suitability-scope/README.md)

## What has been checked

The baseline RDF fixture covers six SPARQL queries, positive and negative SHACL cases,
controlled policy changes, and a small RDFS inference. The Neo4j fixture was
executed against Community 5.26.30: baseline queries, repeatable loading,
unmet-prerequisite exclusion, and multi-topic deduplication pass.
The separate [OWL 2 DL checker](lab/owl_dl/README.md) passed the Graduate and
Exercise 5 cases with HermiT, including profile checks and counterfactual controls.
Historical lab results are retained against unchanged inputs. Fresh baseline RDF/Neo4j
and targeted HermiT runs from version 0.2.0 remain historical evidence; current
checks and remaining limits are in [the release validation summary](publication/release-validation.json). The new
isolated extensions add dated policy, identity/evidence and SHACL/RDFS checks.
The equivalence module retains 145 paired cases: 143 aligned cases agree; two
boundary counterexamples intentionally differ. Independent paired reproduction
remains open. See the validation report for precise scope and versions. These targeted results
do not verify every OWL example, production performance, concurrency, recovery,
or independently reproduce the Neo4j execution.

## Build the book

From the repository root (the folder containing `VERSION`), using Python 3.10+:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements-build.txt -r lab/requirements.txt
.venv/bin/python scripts/validate_release.py
.venv/bin/python scripts/build_pdf.py
.venv/bin/python scripts/export_web.py
.venv/bin/python lab/check_rdf.py
.venv/bin/python scripts/check_package.py
```

On Windows use `.venv\Scripts\python`. Included, separately licensed DejaVu fonts
make the PDF build independent of private system-font paths. The build uses a
fixed source timestamp; the same sources, fonts, and pinned libraries are intended
to give reproducible output. Cross-platform byte equality is not asserted.

See [the full validation sequence](publication/VALIDATION.md) for committed-artifact
checks, fresh-path rebuild comparison and negative controls.

`book/manuscript.md` is the editable source. `=== Part | Title` marks sections;
`@diagram name` selects a renderer diagram or an editable vector in
`assets/figure-sources/`. Generated browser exports never overwrite these inputs.
`book/chapters/` and `assets/figures/` are generated browser-friendly exports.

## Review and feedback

Use [CONTRIBUTING.md](CONTRIBUTING.md) to report an error or confusing step.
Sources, examples, figures, and validation boundaries are supplied so reviewers
can reproduce findings. See [the validation report](publication/VALIDATION.md)
for the checks performed and their scope.

## License and citation

**CC BY 4.0** covers original book text, diagrams, and synthetic example data.
**MIT** covers original code. See [LICENSE.md](LICENSE.md) for the scope and
[LICENSE-CODE.txt](LICENSE-CODE.txt) for the MIT grant. Bundled fonts retain
their included notices.

Version 0.2.1 edition DOI: [**10.5281/zenodo.24483542**](https://doi.org/10.5281/zenodo.24483542).
[CITATION.cff](CITATION.cff) provides this edition's structured citation metadata.

Habibi, M. (2026). *Knowledge Graphs: Semantic Graphs and Property Graphs*
(Version 0.2.1, public review draft). Zenodo. https://doi.org/10.5281/zenodo.24483542

The [published 0.1.0 archive](https://zenodo.org/records/24209668) remains available
under its own DOI. Cite the exact edition you use.
