<h1 align="center">Knowledge Graphs:<br>Semantic Graphs and Property Graphs</h1>

<p align="center">
  <strong>Dr. Mahdi Habibi</strong><br>
  Version 0.1.1 · Public review draft · Release candidate
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
  <a href="https://zenodo.org/records/24209668"><strong>Published book and DOI</strong></a> ·
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

The repository contains the corrected **0.1.1 release candidate**. It fixes
publication-status wording, cover/browser labels, citation details, and packaging.
The technical examples are unchanged. The book and labs are available above.

The [published 0.1.0 archive](https://zenodo.org/records/24209668) remains available.
The corrected 0.1.1 archive is being prepared; its own DOI will be added before
publication. The existing 0.1.0 archive and tag are unchanged.

## What has been checked

The RDF fixture runs six SPARQL queries, positive and negative SHACL cases,
controlled policy changes, and a small RDFS inference. The Neo4j fixture was
executed against Community 5.26.30: baseline queries, repeatable loading,
unmet-prerequisite exclusion, and multi-topic deduplication pass.
The separate [OWL 2 DL checker](lab/owl_dl/README.md) passed the Graduate and
Exercise 5 cases with HermiT, including profile checks and counterfactual controls.
See the validation report for precise scope and versions. These targeted results
do not verify every OWL example, production performance, concurrency, recovery,
or independently reproduce the Neo4j execution.

## Build the book

Requires Python 3.10+:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements-build.txt -r lab/requirements.txt
.venv/bin/python scripts/build_pdf.py
.venv/bin/python scripts/export_web.py
.venv/bin/python lab/check_rdf.py
.venv/bin/python scripts/check_package.py
```

On Windows use `.venv\Scripts\python`. Included, separately licensed DejaVu fonts
make the PDF build independent of private system-font paths. The build uses a
fixed source timestamp; the same sources, fonts, and pinned libraries are intended
to give reproducible output. Cross-platform byte equality is not asserted.

`book/manuscript.md` is the editable source. `=== Part | Title` marks sections;
`@diagram name` selects a vector illustration implemented in the renderer.
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

Until 0.1.1 is archived, cite the published 0.1.0 version using [DOI: 10.5281/zenodo.24209668](https://doi.org/10.5281/zenodo.24209668).
The [Zenodo record](https://zenodo.org/records/24209668) preserves the version 0.1.0 PDF and companion package.
[CITATION.cff](CITATION.cff) provides structured citation metadata.

Habibi, M. (2026). *Knowledge Graphs: Semantic Graphs and Property Graphs*
(Version 0.1.0, public review draft). Zenodo. https://doi.org/10.5281/zenodo.24209668
