# From tutorial to a citable educational book

**Prepared for Dr. Mahdi Habibi · 13 November 2026**

## What the example project teaches us

The supplied reinforcement-learning PDF has 158 pages. I inspected its opening
matter, contents, and selected narrative, derivation, and code pages; this was a
publishing and teaching-structure review, not a full audit of its mathematics.
The linked repository supplies editable sources, code, figures, a citation, and
a link to an archive. Those are useful project features to adopt. They do not
establish that a different book is technically correct or predict its audience.
[Reference repository](https://github.com/dipeshgautam2012/rl-book-project).

Our book's distinctive purpose is to teach a fair RDF/LPG comparison through one
consistent catalog, explicit example boundaries, and matched query outcomes.
We should judge progress by whether readers can follow the explanation,
reproduce the examples, and check the accuracy of the documented claims.

## What Zenodo is

Zenodo is a research repository operated through CERN infrastructure. It preserves
research outputs such as publications, data, and software, and makes records
citable. It is suitable for an educational manuscript and its supporting files.
[About Zenodo](https://about.zenodo.org/).

A **DOI**, Digital Object Identifier, is a persistent identifier for a record.
Readers use its link to locate and cite that record. Zenodo normally registers
one when a record is published; it can also reserve a real DOI while the upload
is still a draft so the identifier can be added to the PDF before publication.
[Zenodo DOI guidance](https://help.zenodo.org/docs/deposit/describe-records/reserve-doi/).

Use a DOI as a citation and preservation tool. Do not present DOI assignment as
journal acceptance, a novelty claim, or evidence of technical peer review. Our
current files have no assigned or reserved DOI, and no identifier is invented.

## GitHub and Zenodo do different jobs

| Place | Main purpose for this project |
|---|---|
| GitHub | Maintain editable chapters, figures, code, checks, change history, and reader feedback |
| Zenodo | Preserve a described, versioned publication package and provide a persistent citation |
| LinkedIn | Introduce the resource and direct interested readers to the real book and project links |

For this manuscript, a direct Zenodo **book/publication record** is the clearest
first archive route: upload the PDF and source/lab archive, then link the GitHub
repository once it exists. Zenodo asks depositors to choose the resource type
that best represents the main contribution; mixed content can be kept together
or split when the components deserve their own records.
[Resource-type guidance](https://help.zenodo.org/docs/deposit/describe-records/resource-type/).

Zenodo also offers GitHub release archiving. Its software workflow is useful for
source and code releases, but it should not silently replace the book's intended
metadata with an inappropriate record description. Check the resulting record.
[GitHub release archiving](https://help.zenodo.org/docs/github/archive-software/github-upload/).

## What has already been prepared

The package contains a revised author-review PDF, the master manuscript,
browser-friendly chapters, original SVG/PNG figures, portable font files and
notices, build/check/export scripts, the RDF and Cypher labs, README, contribution
and issue templates, a workflow, change log, preliminary citation metadata, and
a draft Zenodo description. The author selected preparation of a CC BY 4.0/MIT
license proposal. No external publication action has been taken.

The new manuscript adds the RDF database/server/library distinction, a query
walkthrough, learning goals, and self-checks. Baseline Cypher checks now pass on
Neo4j Community 5.26.30, alongside the existing RDF checks. It remains a review
draft: targeted OWL 2 DL checks for Graduate and Exercise 5 have now passed,
while broader reasoning coverage, production deployment/performance, accessibility
certification, and independent execution remain outside the completed checks.

## Publication path for this exact package

1. **Author review.** Read the final PDF, especially the foundation sequence,
   RDF database explanation, inference-versus-validation chapters, and validation
   report. Decide whether to invite public review under a draft label.
2. **License adoption.** Review the prepared CC BY 4.0 scope for text/figures/data
   and MIT scope for code. Apply the adopted notices consistently. Include the
   existing font licenses. CC BY permits adaptation and redistribution with credit;
   MIT permits broad code reuse with its notice retained. The precise legal texts
   govern. [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/),
   [MIT](https://opensource.org/license/mit).
3. **Project home.** Choose the real GitHub repository and visibility. Upload the
   prepared files with authorization. Check that the PDF and chapter links work
   from that repository and that its checks run there.
4. **Zenodo draft.** Create an account, start an upload, add the reviewed PDF and
   archive, and describe the record. Use the prepared title, creator, version,
   abstract, and keywords; select the appropriate book/publication type. Add an
   ORCID or affiliation only when correct and supplied.
5. **Real DOI and final files.** Reserve a DOI if desired. Add it to the PDF and
   citation metadata, rebuild, rerun checks, and inspect those exact final files.
   Review the complete record before publishing.
6. **Publish and announce.** Publish only after approving the record, files, and
   licenses. Use the actual DOI and repository URL in the README and announcement;
   identify the version and draft/review status. The basic Zenodo workflow is
   upload, describe, and publish. [Quick start](https://help.zenodo.org/docs/get-started/quickstart/).
7. **Maintain versions.** Record corrections in the change log and create linked
   new archive versions for substantive file updates. A new version has its own
   record and persistent identifier while staying linked to earlier versions.
   [Version guidance](https://help.zenodo.org/docs/deposit/manage-versions/).

The live record needs a license selection; Zenodo's default must be consciously
reviewed rather than accepted accidentally.
[License-field guidance](https://help.zenodo.org/docs/deposit/describe-records/licenses/).

## Useful next technical review

Ask an RDF/OWL/SHACL specialist to inspect logical claims, an LPG practitioner
to inspect query and constraint claims, and a beginner to explain the introductory
figures back in their own words. These are proposed review roles, not reviews
already obtained. A report should name the exact version and sections examined.

We can share a clearly labeled review draft to invite this feedback once the
author approves it. Calling it a definitive, peer-reviewed textbook would require
additional evidence. The package is ready for concrete author review; a public
repository, Zenodo record, final licenses, and DOI remain actual publication steps.
