# Consolidated unpublished next-edition changes

All five planned reader-feedback additions are now integrated:
1. Semantic evolution: Section 5.3 decision table, worked changes, historical
   replay, compatible versions and isolated mapping/policy exercise.
2. Eligibility versus suitability: Sections 3.5/4.6 and Chapter 8 agree on claim
   scope, missing evidence, contextual criteria and abstention boundaries.
3. Reasoning value versus cost: Section 2.8 checklist, Section 6.3 pointer and
   workload worksheet; RDFS hierarchy distinguished from the Graduate example.
4. Extraction to identity/evidence: Section 5.2 alias and different-edition cases,
   unresolved identities, predicate mapping and source retention; Chapter 8 pointer.
5. Missing data: Chapter 2 targeted minimum count, datatype-only and untargeted
   cases, unstated versus entailed/unresolved facts, plus actual SHACL/RDFS checks.

Chapter questions, explained answers, core-question suggestions, glossary,
contents/bookmarks, browser chapters, lab directory guidance and package README
are synchronized. No baseline catalog facts or query text were changed. The
research argument and all retained graph-engine evidence are unchanged.

Prior reviewed integration fixes are retained: baseline rules versus Section
10.3 contract, visible nonduplicate chapter footers, rendered citation coverage,
build-input hashes and conceptual practice heading. Browser export now preserves
code-fence and inline-code contents rather than turning indexing literals into
citation links. A new validator checks Q&A sequencing and exported-file hashes.

See VALIDATION.md for executed checks and their limits. The 173-page PDF is an
unpublished working draft; no edition number or DOI has been assigned. Consolidated review corrections are incorporated; complete author release
evaluation before final release preparation. Published 0.1.1 and
prior draft packages remain unchanged.

Consolidated-review corrections:
- Chapter 2 Review numbering repaired and enforced.
- Added actual editorial guards for glossary/core references, per-question answer
  placement, consecutive Review headings, web/source code and section bookmarks.
- Every exported chapter now carries an unpublished notice.
- Reader guide describes the actual next-edition folder layout.
- Section 4.6 separates single-side intake checks from paired correspondence.
- The requires label uses code styling, and PDF metadata identifies the draft.
- CI validates committed artifacts first, then compares text/navigation after
  rebuilding. Runtime metadata and byte-reproducibility limits are explicit.
- Nineteen document regression probes and five rebuild comparison controls pass.
