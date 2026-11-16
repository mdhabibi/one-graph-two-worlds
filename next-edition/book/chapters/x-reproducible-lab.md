# X · Reproducible lab

**Unpublished next-edition working draft. No edition number or DOI assigned.**

## 10.1 Files, versions, and execution boundaries

We now move from reading examples to reproducing them. This section identifies the complete lab files and separates checks you can run locally from behaviors that require a configured database or reasoning engine. Begin with a clean baseline before trying any model extension.

### The companion lab
The separate research experiment in research/ tests the query-alignment contract; Sections 10.3–10.5 explain its argument, evidence and reproduction boundaries.

The downloadable lab contains the baseline RDF catalog, SHACL shapes, an OWL example, SPARQL queries, a full Cypher loader and query set, and a small RDF checker. A README lists commands and expected answers. The examples are synthetic and intended for a dedicated exercise environment.

### Isolated editorial extensions
The extensions directory contains separate exercises for semantic evolution, identity/evidence handling and missing-data validation. Their READMEs identify inputs, dependencies, expected results and limits. The reasoning-decision worksheet reuses the existing RDFS and optional DL examples without claiming a new benchmark. Run extensions separately: none modifies the baseline catalog, existing queries or retained equivalence experiment.

### RDF route
Create a local Python environment and install the pinned dependencies listed in the lab. Run the checker to parse the graphs, execute the baseline queries, and evaluate the shapes. The checker also injects a missing-duration defect to verify that validation reports it. The basic RDF checker parses the OWL example but does not execute a DL reasoner. A separate optional checker in lab/owl_dl uses HermiT, a complete OWL 2 DL reasoner, for the Graduate definition and the contradictory-classification exercise. In the recorded run, all four input fixtures passed the OWL 2 DL profile check; Maya and Leo were classified as Graduate, the disjointness example was inconsistent, and the two counterfactual controls behaved as expected. The companion report records versions, input hashes, and limits. This is targeted verification of those examples, not a claim that every OWL example or production deployment has been tested.

**Local lab commands — create an environment and run the checker.** Run these from the extracted lab directory. They install the listed Python libraries and execute check_rdf.py; they do not start a Neo4j server.

```text
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python check_rdf.py
```

The checker prints a concise result and exits with failure if an expected result changes. This is a learning fixture, not a performance test. A local RDF library does not demonstrate triplestore behavior under concurrent updates or large datasets.

### Neo4j route
Use a dedicated exercise database with a Neo4j 5-compatible Cypher environment. Execute the full loader from the companion files, then the provided read queries. Statements use semicolon separators. Query tools differ in whether they accept a whole script or require one statement at a time. Validate four courses, two people, three topics, and recommendation result c2.

The lab includes a Docker-based checker for an empty, dedicated database. Its baseline and named policy cases were executed against Neo4j Community 5.26.30 on 13 November 2026. The validation report records the scope and observed results; the checker does not install a production server. A successful fixture check is not a test of concurrent writes, recovery, or production performance. Newer releases may introduce schema and path features beyond this baseline. [[2](xii-references.md#ref2), [6](xii-references.md#ref6), [7](xii-references.md#ref7)]

### Keep the experiment honest
Do not combine extension snippets with the baseline and expect unchanged counts. The event, named-graph, provenance, and Graph RAG examples illustrate later modeling choices. Treat each extension as a controlled migration, update the expected answers, and retain the original fixture for comparison.

## 10.2 Expected outputs and extension checklist

After loading the baseline, compare your results with the table below. These values describe the unchanged starting catalog. The later checklist proposes separate extensions; each requires a deliberate model and test update rather than an unexplained change to the expected answers.

| Check | Expected baseline result |
|---|---|
| Explicit Course instances | 4 |
| Explicit Person instances | 2 |
| Topic entities | 3 |
| Courses about Graphs | c1, c2 |
| Courses lasting at most 75 minutes | c1, c3, c4 |
| Prerequisite reachable from c2 | c1 |
| Distinct courses by topic | RDF: ex:graphs 2, ex:data 1, ex:ethics 1 (expanded IRIs); Cypher: graphs 2, data 1, ethics 1 |
| Maya's eligible recommendation | c2 / Graph Search |
| CourseShape on baseline | Conforms |
| CourseShape after removing c2 duration | Does not conform |

### Add one requirement at a time
**Multilingual catalog:** change title modeling and shapes to accept language-tagged values, then define preferred-language fallback. Preserve both languages in any RDF/LPG mapping.

**Course editions:** introduce offering or edition IDs. Define whether completion of one edition satisfies a prerequisite for another. Update evidence and migration rules.

**Temporal eligibility:** add event time, expiration, and policy time. Distinguish a fact's real-world validity from when the system learned it. Query eligibility as of a declared time.

**Prerequisite alternatives:** represent “c1 OR an equivalent assessment” as an explicit requirement group rather than adding two simple REQUIRES edges, which the current policy interprets conjunctively. The model and query must change together.

**Course retirement:** add lifecycle state and ensure eligibility filters it. Keep historical references valid for past completions and audit records.

**Evidence-aware answers:** require a reviewed source and locator for each user-facing claim. Add negative test cases where the source is absent, stale, or inaccessible. The correct answer can be abstention rather than a guess.

> When a requirement changes, revisit the conceptual model, acceptance rules, query semantics, and expected outputs together. A field added to storage is only one part of the change.

## 10.3 When do the two recommendation queries mean the same thing?

Section 4.6 introduced the baseline intake rules. This section gives a precise sufficient alignment contract and distinguishes it from those stronger intake requirements. The earlier chapters expressed one catalog policy in SPARQL and Cypher. Maya likes Graphs, has completed Graph Basics (c1), and has not completed Graph Search (c2). Course c2 concerns Graphs and requires c1. Both baseline queries return c2 / Graph Search. A matching answer is a useful starting observation, but it does not establish that two representations always mean the same thing.

Suppose a loader silently omits a prerequisite, stores two titles as one list, or materializes Course membership on only one side. Both queries may still run successfully. To explain when their answers must agree, we need a representation contract and a precise policy, not just two successful executions.

### State the policy before comparing syntax
Let Liked(m) be the topics linked from learner m, About(c) a course's topics, Done(m) the completed courses and Required(c) the direct prerequisites. For a Person learner and a Course with both output fields present, the policy is:

```
Eligible(m,c) =
    Liked(m) intersects About(c) is nonempty
    AND c is not in Done(m)
    AND Required(c) is a subset of Done(m)
```

The last line means every recorded direct prerequisite is completed. An empty prerequisite set satisfies this condition. A prerequisite of a prerequisite is not automatically added to Required(c). These are choices in the catalog policy, not conclusions about prerequisite completeness, personal suitability or educational outcomes.

### A: align the query-relevant facts
Call the identity correspondence phi. It must be a bijection between the selected RDF resources and their corresponding LPG nodes: distinct identities stay distinct, and no extra query-relevant LPG node is left unmatched. The selected fragment contains Maya's identity, all Person and Course instances, and the endpoints of likesTopic, about, completed and requires. The mapping in this experiment uses IRIs for those RDF identities; blank-node or literal-node encodings need a separately specified mapping.

For each selected identity, Person and Course membership must match their LPG labels in both directions. For each pair of identities, each of the four mapped relationships must exist in RDF if and only if its correctly directed LPG relationship exists. Preserving existing source facts is insufficient if the destination also introduces extra candidates or edges. Parallel LPG edges reduce to one endpoint pair for this existence-based query.

The LPG Person nodes with id maya must correspond exactly to Maya when RDF gives her Person membership. If that membership is absent on both sides, neither query can bind its learner and both return empty. The contract therefore does not require a valid learner record in order to explain equal exclusion.

Each Course may have zero or one id and zero or one title. Any present value must be an untagged xsd:string, preserved as a scalar LPG string. Missing fields must remain missing: the RDF mandatory pattern cannot bind them, and the Cypher IS NOT NULL filters reject the candidate. Multiple titles stored as a list violate this particular projection contract. Language-tagged terms retain their language and rdf:langString datatype in evidence, but are outside this simple string mapping [[1](xii-references.md#ref1), [4](xii-references.md#ref4), [6](xii-references.md#ref6)].

Neither query requires a Topic label, Course membership on a prerequisite endpoint, or globally unique output IDs once identities and projected values are preserved. The supplied loader can still impose stronger requirements. The two systems must expose the same selected snapshot and query-visible inference. An inferred Course on one side without corresponding membership on the other breaks alignment.

### Why the argument works
A shared-topic witness exists in RDF exactly when the corresponding LPG path exists. A completed-course exclusion has the same witnesses on both sides. The nested NOT EXISTS pattern rejects a course when a direct prerequisite exists without a matching completion. Because both relationships and identities are preserved and reflected, an unmet witness exists on either side exactly when it exists on the other.

A missing output field excludes the candidate on both sides. Otherwise, scalar string preservation gives the same id/title pair. DISTINCT removes repeated witnesses, yielding equal sets of output pairs. If the Person anchor is absent on both sides, both result sets are empty before these tests apply.

This is a conditional argument for the exact published query pair. It is not machine-checked verification, equivalence of arbitrary SPARQL and Cypher, or a claim about every RDF/LPG encoding. Named graphs, other datatypes, aggregation, update semantics and different inference regimes need their own contracts. The complete protocol is retained in research/equivalence/PROTOCOL.md.

## 10.4 Separate query alignment, fixture integrity and intake validation

A query can return the same answer in two systems while both contain a record that should be rejected at intake. To avoid mixing those conclusions, the experiment records three judgments.

| Judgment | What it asks | What a pass does not establish |
|---|---|---|
| A: query alignment | Are the query-relevant identities, memberships, edges, anchor and output fields aligned? | Complete business evidence or acceptable intake data |
| B: fixture integrity | Do stronger fixture rules and the broader projected state agree? | General round-trip preservation of every property |
| C: SHACL intake | Does the RDF graph satisfy the supplied shapes? | Cross-system identity reconciliation or factual truth |

B includes a Person learner, exactly one string id/title per Course, unique Course IDs and Course prerequisite targets. Its state component also compares Topic, OnlineCourse and Completion membership, event edges, node presence and selected fields outside A's minimal query fragment. It is deliberately stricter than A. C separately checks the unchanged CourseShape and LearnerShape, including positive duration [[5](xii-references.md#ref5)].

Removing c2's title makes both recommendation queries omit it, but the record fails B and C. Removing Maya's Person membership also produces equal empty answers while failing intake. An untyped prerequisite endpoint and a missing course ID give the same distinction. Agreement is not a substitute for validation.

### Retained observations
The controlled suite uses 145 datasets: 17 curated cases and a complete 128-case bounded grid. The grid varies c2's prerequisites over subsets of {c1,c3}, Maya's completions over subsets of {c1,c2,c3}, and her interests over subsets of {graphs,data}. That is 4 x 8 x 4 combinations, with all other baseline facts fixed. A separately expressed set predicate supplies expected answers; it was developed within this same project, not by an independent team.

| Observation | Retained result |
|---|---|
| Datasets executed by both engines | 145 |
| Query-aligned cases, A | 143; all return equal pairs |
| Stronger fixture integrity passes, B | 139 |
| SHACL intake passes, C | 140 |
| Deliberate unequal recommendation results | 2: B01 and B03 |
| Parallel completion observations | RDF count 1; LPG count 2 |
| Explicitly identified completion events | RDF count 2; LPG count 2 |

These are counts within a constructed suite, not a statistical accuracy score. A named positive control gives c2 two prerequisites and completes both; c2 must remain eligible. This catches a faulty implementation that accepts at most one prerequisite. A grid that never includes completion of c3 would miss this positive combination.

### Learn from the two disagreements
In B01, RDF has two scalar titles for c2, while the selected LPG representation stores a list-valued title. SPARQL returns two scalar rows and Cypher returns one row containing a list. A fails because the output mapping is different. This does not mean either model cannot represent repeated or multilingual values.

In B03, RDFS materialization makes c2 a Course from OnlineCourse membership on the RDF side. The LPG carries OnlineCourse but lacks Course, so Cypher excludes it. This is an inference-alignment failure, not evidence that one model is generally superior. C13 is a separate control with aligned explicit memberships; it does not test aligned inferred membership.

The parallel-completion case demonstrates another boundary: the DISTINCT recommendation agrees while occurrence counts differ. Reasserting an identical RDF triple does not add a second triple; creating a parallel LPG relationship does add another relationship. Explicit Completion identities preserve the two occurrences in the isolated event repair. Query-specific equivalence does not imply equivalent event histories.

### State the evidence limit accurately
The retained run records Python 3.12.14, RDFLib 7.1.4, pySHACL 0.30.1, owlrl 7.1.4 and Neo4j Community 5.26.30, with input hashes, raw output, image identity and per-case state projections. Its paired results were obtained in one project environment. Independent paired reproduction remains open. Multiple local reruns do not constitute a second environment or human peer review.

The claim is that all 145 cases matched their expected observations, including two disagreements; it is not that the queries returned equal answers on all 145. No timings, maintenance-cost measurements, GraphRAG answer-quality results or personal-fit validation are established by this experiment.

## 10.5 Reproduce and challenge the equivalence experiment

The research directory contains a separate, inspectable experiment. Its six baseline source files are unchanged copies of the published 0.1.1 lab. Read research/equivalence/README.md for installation and exact fresh-output commands. Read the protocol before interpreting a passing run.

### Reproduce without replacing evidence
The default runner checks RDF and SHACL only. Its report explicitly says Cypher was not run; paired-verification fields remain null. Paired mode creates its own disposable Neo4j 5.26.x instance, with no host ports and no existing database. It retains the exact Cypher script, raw output, runtime identity and source hashes. Use a fresh report path for each run.

In paired mode the runner checks both answers and exported state. An undeclared full-fixture mismatch stops the run, even if the answer is unchanged. If a mutation meant to remove a Topic label silently matches no node, the recommendation can stay unchanged. The state comparison exposes that failed mutation. Function-level controls also show that an irrelevant isolated node can preserve A while failing B's broader state check; that is not currently a declared paired-suite case.

The summary generator checks that the only unequal cases are B01 and B03 and that the four malformed cases have their declared A/B/C outcomes before writing prose. Its evidence inventory identifies inputs, raw outputs, classifications, control reports and document checks using package-root-relative paths. Auxiliary tools accept fresh output destinations and refuse existing targets. Synthetic metadata probes and simulated engine-output corruption are labeled separately from actual engine execution.

### Try these before reading the solutions
These questions ask you to reason about the contract and evidence rather than write a new query.

1. Both representations omit c2's title. Must A fail because C fails?
2. An extra prerequisite edge is added in RDF but not in the LPG. Can a matching answer establish alignment?
3. Two direct prerequisites are recorded and both are completed. What result would expose an incorrect at-most-one-prerequisite rule?
4. A simulated output-corruption test passes. Has another Neo4j execution occurred?
5. An extra isolated Topic node leaves A unchanged but makes the fixture check fail. Is that a contradiction?

### Practice solutions — compare after trying
**Solution 1.** No. Matching absence is allowed by A's zero-or-one output-field contract, so both queries exclude the candidate. The supplied intake rules still require its title, so B and C fail. Equal exclusion is not an acceptable catalog record.

**Solution 2.** No. Edge preservation and reflection already fail, whether or not another filter happens to hide the answer difference. Check state and source completeness separately from answer equality.

**Solution 3.** An otherwise eligible c2 must still be returned. If it disappears merely because two prerequisites exist, the implementation has replaced the intended subset condition with an extra restriction. The named all-prerequisites-completed control exercises this positive case.

**Solution 4.** No. Replaying recorded output with a deliberately changed record checks the harness's rejection logic. It is useful evidence about the checker, but not a new database-engine execution or an independent environment.

**Solution 5.** No. A deliberately ignores that node; B checks a broader fixture. The strict runner stops on undeclared fixture differences. A future study could declare an A-only paired case, but this suite currently demonstrates the distinction through function-level controls.

> Start with the decision policy, specify the mapping, compare actual state as well as answers, and state precisely which conclusions the evidence supports.
