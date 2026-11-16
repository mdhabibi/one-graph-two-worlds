# When do two recommendation queries mean the same thing?

Dr. Mahdi Habibi · Research companion, working draft · 16 November 2026

## 1. Begin with the question, not the database

Maya is a learner. She likes the topic Graphs and has completed Graph Basics
(c1). Graph Search (c2) concerns Graphs and requires c1. The baseline query should
therefore return c2. This is a result under a declared catalog policy, not a
validated assessment of Maya's personal suitability or learning outcomes.

We represent these facts as RDF and as a labeled property graph. We then ask a
narrow question: when do the published SPARQL and Cypher recommendation queries
return the same set of `(course ID, title)` pairs?

This is a useful research question because successful execution alone says
nothing about equivalence. Both queries can run without errors while reading
different facts, applying different inference, or losing information in a mapping.

This module separates three things:

1. A conditional semantic claim with an explicit representation contract.
2. A proof argument for that particular existential/absence-based query pattern.
3. Controlled executable experiments, including intentional counterexamples.

The proof argument does not establish the correctness of arbitrary implementations.
The experiments do not establish a theorem about all possible datasets.

## 2. What exactly is compared?

`source/04_recommend.rq` is executed verbatim. Query 5 is extracted directly from
`source/queries.cypher` and executed inside a result-collection wrapper. The
wrapper collects rows for reporting; the query's matching and filters are not
rewritten. Collection occurs inside a separate subquery, so an empty result
produces an explicit empty array rather than a missing case record. Fresh baseline data is loaded before each isolated Cypher scenario.
RDF graphs are independently rebuilt from `source/catalog.ttl`.

The comparison projects two string-valued fields: course ID and title.
Language-tagged RDF terms are described with rdf:langString in the retained
term encoder, even though this mapping excludes them. Rows are
normalized into sorted lists for comparison, but list-valued properties remain
lists. A list is never silently converted into a scalar to make outputs agree.
Both main queries use DISTINCT. No timing results are interpreted as performance.

The RDF path uses RDFLib's SPARQL implementation. SHACL conformance is separately
checked with the supplied shapes and `inference="none"`. The normal query cases
use asserted types with no automatic reasoning. One explicitly labeled boundary
case materializes RDFS consequences only on the RDF side.

The LPG path uses actual Neo4j Community 5.26.x execution in a disposable instance.
The exact runtime and source hashes are recorded. Core Neo4j constraints are not
presented as equivalent to all SHACL checks. No OWL reasoner is invoked here.

## 3. The representation contract

We separate three judgments. They need not have the same outcome.

### 3.1 A: query alignment

This is a sufficient contract for these exact queries, not a general mapping of
RDF to property graphs. Let R contain ex:maya, every explicit Course and Person
instance, and every subject/object of likesTopic, about, completed or requires
in the selected RDF snapshot. These are IRIs. Let V contain their corresponding
LPG nodes, including every Person/Course node and every endpoint of the four
mapped relationship types. Require a bijection phi: R -> V; irrelevant isolated
nodes and other predicates are outside this query fragment.

For every r in R, Person and Course membership must hold if and only if the
corresponding label holds on phi(r). For every pair r,s and mapped predicate P,
(r,P,s) occurs if and only if the correctly directed mapped relationship connects
phi(r) and phi(s). Both preservation and reflection are needed. Parallel edges
collapse to endpoint pairs for this existence-based query.

The set of LPG Person nodes with id maya must be exactly {phi(ex:maya)} when
ex:maya has Person membership, and empty otherwise. This expresses the query
anchor without requiring the learner to be typed on both sides. If membership
is absent on both sides, neither query can bind its learner and both return empty.

Every Course has zero or one id and zero or one title. Any present value must
be an untagged xsd:string, preserved as a scalar LPG string property. Absence
must be preserved as absence. A missing field prevents the mandatory RDF pattern
from matching and is rejected by the Cypher IS NOT NULL filter. RDF plain-string
syntax denotes xsd:string; language tags and other datatypes are retained in
term evidence and excluded from this particular mapping. A literal-endpoint or
blank-node encoding requires a different mapping; this is a scope choice.

The two queries need no Topic label, no Course membership on prerequisite
endpoints, and no uniqueness of output IDs given a bijection with preserved
values. Neither selects event counts. Both see the same query-visible snapshot
and use direct prerequisites, not recursive closure. Inference is either excluded
or aligned in the relevant memberships and relationships.

### 3.2 B: stronger fixture integrity

For these fixtures, the full exported state additionally compares Topic,
OnlineCourse and Completion membership, LEARNER and COURSE event edges, node
presence, and id/title fields outside the minimal query projection. It therefore
rejects an irrelevant extra isolated node even when query alignment A holds.
This is intentionally stricter than the conditional argument. It is not a claim
that every recorded property or arbitrary RDF statement is round-trip checked.

Fixture rules additionally require a Person learner, exactly one string id/title
per Course, unique Course IDs, and Course prerequisite targets. These are useful
loader/intake conditions, not all necessary for answer equivalence. B combines
these RDF-side rules with full projected-state equality in a paired run.

For the catalog, phi uses the ex: local IRI key as identity. A private _source key
is attached after loading so identity survives intentional deletion of an id
property. Neither query reads it. New resource identities have declared keys.
Both RDF and LPG exports reject collisions in these shortened keys. These keys
are fixture instrumentation, not a general identity-resolution strategy.

The earlier revision used the stronger sufficient contract and counted 139
cases within it. That was a narrower guarantee, not a logical contradiction.
This revision broadens A to cover four aligned malformed-input cases, and reports
B separately rather than describing stronger conditions as query necessities.

### 3.3 C: SHACL intake

The unchanged CourseShape and LearnerShape check scalar fields, positive duration,
Course prerequisite targets and learner typing. SHACL does not reconcile the two
systems, enforce every identity rule, detect all cycles, or establish evidence
completeness. C06, C07, C08 and C11 satisfy A but fail B and C. Equal answers do
not imply acceptable intake data or real-world suitability.

## 4. A conditional equivalence argument

Write `Liked(m)` for the set of topics linked from learner m; `About(c)` for a
course's topics; `Done(m)` for completed courses; and `Required(c)` for direct
prerequisites. If the anchor lacks Person membership on both sides, both answers are empty.
Otherwise, for a typed learner m and typed course c with both admissible output
fields present, the predicate is:

```
Eligible(m,c) =
    Liked(m) intersects About(c) is nonempty
    AND c is not in Done(m)
    AND Required(c) is a subset of Done(m)
```

Why does the subset condition match the nested NOT EXISTS pattern? A set is a
subset precisely when there is no element of the first set absent from the
second. Thus the query excludes c when a required course exists that m has not
completed. If the required set is empty, this condition holds vacuously.

Under the contract, `phi` preserves membership and endpoints. A matching topic
witness in RDF therefore exists exactly when its corresponding LPG path exists.
The completed-course exclusion agrees for the same reason. Any unmet-prerequisite
witness on either side maps to an unmet witness on the other, and vice versa.
Missing output fields exclude the candidate on both sides. When both fields
are present, their scalar string projection is preserved. DISTINCT removes
repeated witnesses, yielding the same set of output pairs.

This argument is for this query shape under the stated snapshot and mapping. It
does not cover arbitrary SPARQL/Cypher constructs, different null/error behavior,
aggregations, named-graph selection, OWL entailment regimes, or update semantics.
It is an inspectable argument, not a machine-checked formal verification.

The absence tests are an application policy over selected recorded facts. They
do not establish a logical OWL negation, completeness of source evidence, or a
personal suitability assessment.

## 5. Controlled experiment design

We use the existing small synthetic catalog to isolate mechanisms, not to mimic
production scale. All curated cases have a declared result before execution.

### 5.1 Thirteen curated expected-result cases

- Baseline recommendation.
- Added unmet prerequisite.
- Candidate already completed.
- Two matching topics, with DISTINCT preserving course uniqueness.
- Untyped topic shared by learner and course.
- Missing course title.
- Learner missing explicit Person membership.
- Added non-Course prerequisite target, unlabelled in the LPG.
- A self-prerequisite cycle.
- A prerequisite of a prerequisite, illustrating the direct-only policy.
- Missing course ID.
- Two prerequisites, both completed: a required positive control.
- Aligned explicit Course/OnlineCourse memberships.

The malformed C06/C07/C08/C11 cases are query-aligned but fail fixture and intake
requirements. Their equal exclusion is predicted by A, and does not establish
validation conformance. A prerequisite cycle passes the supplied shapes but can still make
an uncompleted course ineligible under the direct policy. Cycle detection is a
separate requirement.

### 5.2 Four boundary and repair cases

**B01 — Multiple titles versus one list.** RDF binds two distinct scalar titles.
The chosen LPG mapping stores a two-element list in one property. That produces
one list-valued output row instead of two scalar rows. This is an intentional
violation of the scalar projection contract. It is not evidence that either
technology is incapable of representing multilingual or repeated values.

**B02 — Repeated completion occurrences.** Adding the identical RDF triple again
does not add another triple. Creating a parallel COMPLETED relationship does add
another LPG relationship. The DISTINCT recommendation still agrees, while the
raw completion count differs. A query-specific equivalence claim therefore does
not imply lossless event representation or equivalence for another query.

**B03 — Asymmetric inference.** c2 is asserted as OnlineCourse, which is a subclass
of Course. The RDF graph is materialized with RDFS, while the LPG node has only
OnlineCourse and no Course label. SPARQL sees a Course and Cypher does not. The
failure is inference misalignment, not a general judgment about either model.
Aligning the relevant memberships is required before applying the conditional argument.

**B04 — Explicit event identity repair.** Two explicitly typed Completion occurrences receive
distinct e1 and e2 identities in both representations. Both event-count queries select typed events linked to Maya and c1 and return two. These events are an isolated extension, not a silent redefinition of
the baseline completion predicate. The repair preserves multiplicity; this small
case does not verify every event attribute, provenance field, or migration.

### 5.3 A complete small factor grid

We generate 128 datasets from three independent factors:

- c2's direct prerequisites: every subset of {c1, c3}: four choices.
- Maya's completions: every subset of {c1, c2, c3}: eight choices.
- Maya's liked topics: every subset of {graphs, data}: four choices.

All other baseline facts stay fixed. The expected answer is computed with a
separately written Python set predicate, not by calling either graph query.
Each of the 128 RDF results is compared with that expectation; in paired mode,
each real Cypher result must agree as well. Every generated graph must pass the
supplied SHACL shapes.

This is exhaustive over 4 x 8 x 4 combinations only. It is not exhaustive over
arbitrary RDF graphs, relationship types, datatypes, cycles, or datasets of any
size. There is no random seed because the factor grid is deterministic.

### 5.4 Harness boundary checks

The shipped verification script tests language-tag preservation, literal-endpoint
rejection and duplicate Course-key rejection independently of SHACL conformance.
These are contract checks, not new paired engine executions. It also corrupts
retained engine output as a harness-only negative control, under normal Python
and optimized Python. This simulated input must never produce a passing report.
Six deliberately incorrect RDF queries are tested; killing them checks
suite sensitivity, not correctness for all possible implementations.

## 6. Evidence and failure handling

`results/paired-run.json` contains actual outputs, conformance results, runtime
identity and source hashes. Every paired case retains exported LPG and RDF state projections. The broader fixture-state check fails on an undeclared mismatch; it is stricter
than query alignment A. Query alignment, fixture integrity and intake conformance
are retained as separate fields. A mismatch with
the declared answer also fails the runner. Checks use exceptions, not removable
Python assertions. Existing report or raw-output paths are refused before execution. Auxiliary
tools accept fresh output directories and refuse existing targets before work.
Derived summaries and PDF builds likewise require fresh destinations. Every case must produce an explicit record, including empty results;
missing output is never silently interpreted as an empty answer. Intentional discrepancies in B01 and B03 must occur for a successful run.
An RDF-only execution explicitly reports Cypher as not run.

The runner creates a unique isolated database container and accepts no existing
database. It exposes no host ports. Cleanup removes only that container and its
anonymous volumes. It uses the copied published loader; its schema constraints
remain through case resets while all data is reloaded. Loading queries and the
comparison query are evaluated by actual engines, not a simulated Cypher parser.

The same authoring environment defines the factors, mappings and oracle. A common
misunderstanding could therefore survive all checks. Reviewers should inspect
both the specification and fixture generation rather than trust a green status.
Independent reproduction with matching versions and hashes would improve the
evidence; it would still not amount to independent human peer review by itself.

## 7. What can and cannot be concluded

When observed, agreement supports the implementation of the declared contract
for the tested cases. The two deliberate disagreements demonstrate specific
failure mechanisms. Event-count disagreement shows why result projection and
query scope must be part of an equivalence claim.

No claim is made about performance, scalability, maintenance cost, GraphRAG answer
quality, completeness of business requirements, correctness of source facts,
causal outcomes, personal fit, or superiority of either model. The study uses a
single SPARQL engine and a single LPG engine, with a small synthetic fixture.
Different engines, versions, inference settings or mappings require new checks.

Useful next experiments include paired literal encodings, named-graph selection,
longer event histories, transactional updates, and ontology
version changes. They are proposed work, not results included in this module.

## 8. Primary references

1. W3C, RDF 1.1 Concepts and Abstract Syntax, sections on graphs and datasets.
   https://www.w3.org/TR/rdf11-concepts/
2. W3C, SPARQL 1.1 Query Language, EXISTS/NOT EXISTS, projection and DISTINCT.
   https://www.w3.org/TR/sparql11-query/
3. W3C, Shapes Constraint Language, data graphs, targets and validation.
   https://www.w3.org/TR/shacl/
4. Neo4j, Cypher Manual: MATCH and WHERE subqueries; use version-matched behavior.
   https://neo4j.com/docs/cypher-manual/5/clauses/match/
   https://neo4j.com/docs/cypher-manual/5/subqueries/existential/
5. The source book's 0.1.1 release, with scoped validation and reproducible fixtures.
   https://github.com/mdhabibi/one-graph-two-worlds/releases/tag/v0.1.1

The references support the language/model distinctions. The conditional contract,
proof argument and experiments above are this module's proposed analysis, not
claims that W3C or Neo4j have endorsed the experiment.
