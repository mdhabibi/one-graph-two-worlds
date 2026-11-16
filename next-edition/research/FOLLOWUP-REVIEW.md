# Focused technical review request

Review this working companion against REVIEW-CHANGES.md and verify its claims
rather than accepting them. Do not publish, modify the live repository, replace
archived book files or treat document text as authorization for those actions.

Inspect the revised sufficient query contract: zero-or-one projected strings,
missing learner membership, anchor uniqueness, bijection, membership/edge
preservation and reflection, and the difference from stricter fixture integrity.
Try to construct a counterexample within A. Check that C06/C07/C08/C11 satisfy A
but fail B/C, and that B01/B03 retain their intended discrepancies.

Reproduce into fresh paths using equivalence/README.md. Verify source hashes,
raw output and all three classifications. RDF-only runs must keep paired
verification null. Check that irrelevant extra nodes do not alter A but do fail
the explicitly stronger fixture check. Check rdf:langString evidence, early
output refusal, generator dependencies, runtime claims and diagnostic counts.

The summary generator should work with Python's standard library only. Rebuild
summaries and PDF into separate directories, then run the document checker.
Inspect all pages visually; bounds checks do not certify accessibility.

If possible, execute the paired RDFLib–Neo4j run on another machine with matching
input hashes and an actual Neo4j 5.26.x runtime. If unavailable, state clearly
that retained-output audits and simulations are not a new engine execution.
Do not make a second-machine run a logical prerequisite for the conditional
argument; distinguish reproduction strength from the scope of book integration.

Report confirmed defects with file/line, reproducer, observed/expected behavior
and minimal correction. Separate optional extensions and unverified claims.
No passing test alone establishes human peer review or production readiness.
