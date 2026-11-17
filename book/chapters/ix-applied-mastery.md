# IX · Applied mastery

**Version 0.2.0 · Public review draft · Edition DOI: 10.5281/zenodo.24316420**

## 9.1 Common mistakes and how to repair them

We have covered representation, meaning, queries, and operation. This section collects mistakes that cross those boundaries. Use the repair column to decide which layer to inspect when the catalog produces an incorrect or unexplained recommendation.

| Mistake | Why it fails | Better practice |
|---|---|---|
| Compare RDF to a database as equivalent categories | Model, language, semantics, and runtime get mixed | Compare full candidate stacks by requirement |
| Use course titles as IDs | Renames and duplicates break identity | Stable IDs plus editable labels |
| Treat domain / range as validation | RDFS can infer unexpected types | Use explicit acceptance rules such as SHACL |
| Use OWL cardinality as a form validator | Logical existence differs from submitted values | Validate the supplied graph separately |
| Use sameAs for near matches | Identity has strong semantic consequences | Preserve uncertain mappings with evidence |
| Put every relation attribute in a single string | Multiplicity, units, and provenance disappear | Typed values or explicit event / claim nodes |
| Assume ontology edges execute themselves | Stored hierarchy is not an inference engine | Specify rules, runtime, and recomputation |
| Count every joined row as one course | Multi-valued patterns multiply solutions | Define the counting unit and scope |
| Use unbounded traversal by default | Fan-out can make costs unpredictable | Selective anchors, bounds, limits, timeouts |
| Claim graph RAG guarantees truth | Retrieval and generation can both fail | Evidence checks, access filters, abstention |
| Choose hybrid storage without ownership | Conflicts and drift become permanent | Assign authority and make projections rebuildable |

### Debug in dependency order
If a recommendation is wrong, first verify identity and source facts. Then inspect policy, graph scope, validation results, and query bindings. Check duplicate paths and stale projections. Only then change ranking or language generation. A fluent explanation cannot repair a wrong entity merge.

A useful debugging artifact is a minimal failing subgraph: the smallest set of entities and facts that reproduces the error. Keep it with the expected answer as a regression fixture. This is more informative than a screenshot of a large, colorful graph with no precise failure condition.

## 9.2 Guided exercises with answer explanations

Use these exercises to check that the catalog story still makes sense as the representation becomes more technical. Start each exercise from a fresh baseline unless it names a separate ontology scenario. Read the proposed change, predict the effect, and then compare your reasoning with the answer.

### 1 · One missing duration
Remove c2's duration from the RDF dataset. What changes?

**Answer:** a topic query still returns c2. The positive-duration CourseShape fails because no value is present for the mandatory path. An ontology can remain consistent. This demonstrates the independence of query matching, validation, and logical consistency.

### 2 · Two liked topics
Add Data to Maya's liked topics and add Data as a second topic for c2. What should the recommendation query return?

**Answer:** c2 and c3, once each with DISTINCT. c2 can match via Graphs and Data before projection deduplication. c3 now matches a liked topic and its only recorded prerequisite c1 is completed. c4 does not match a liked topic. Eligibility still assumes prerequisite completeness.

### 3 · A new unsatisfied prerequisite
Add `c2 requires c4`, leaving Maya's completions unchanged. What happens?

**Answer:** c2 becomes ineligible under the policy. The nested absence test finds c4 as a counterexample: it is required and has no matching completion. A ranking score cannot override this hard rule unless the policy is deliberately changed.

### 4 · Repeated completion attempts
Maya attempts c1 twice, scoring 0.4 and 0.9. How should the graph represent this?

**Answer:** use separate attempt or completion-event IDs. Define which outcomes qualify as completed. A single RDF completion triple or one LPG relationship with one overwritten score loses occurrence history. If a direct completion relationship is kept, derive it from qualifying events and define revocation behavior.

### 5 · A contradictory classification
For this isolated variation, the disjointness statement is ex:Person owl:disjointWith ex:LearningResource . Here owl:disjointWith says that the two classes cannot share a member. The owl prefix is the namespace used in the earlier OWL examples. Someone uses an about property with LearningResource as domain on Maya, who is typed Person. What follows?

**Answer:** under the relevant RDFS and OWL semantics, Maya is inferred to be a LearningResource, creating a disjointness conflict. Removing the disjointness only to hide the symptom may weaken the model incorrectly; inspect whether the property assertion or domain commitment was wrong.

## 9.3 Architecture case studies and model answers

The exercises changed individual facts. We now change the project requirements instead. Each case is a separate hypothetical setting, not a continuation of the previous case. Follow the requirement that drives the proposal and the evidence still needed before adoption.

### Case A · A shared curriculum exchange
Several independently governed catalogs must exchange course descriptions with stable identifiers, multilingual labels, explicit meaning, and machine-checkable intake rules. Consumers also need subclass-based discovery.

**Reasoned proposal:** evaluate RDF with shared IRIs, a reused or carefully designed vocabulary, lightweight RDFS or an appropriate OWL profile, SHACL intake validation, and SPARQL. Keep edition identity and source provenance explicit. Test consumer interoperability and selected reasoning behavior. Do not assume an ontology eliminates reconciliation or ownership disputes.

### Case B · An interactive learning application
One team owns the catalog and completion service. The main requirements are rapid product iteration, relationship-based recommendations, interaction history, and explanations. Formal semantic exchange is currently optional.

**Reasoned proposal:** evaluate Neo4j LPG/Cypher with stable IDs, completion-event nodes where history matters, native identity constraints, domain validation, and parameterized policy queries. Preserve canonical IRIs if future export is plausible. Validate latency and ingestion under realistic load. RDF remains a viable candidate; the decision depends on team and operational evidence.

### Case C · Both exchange and application workloads matter
A governed semantic catalog must feed an interactive application that needs a different optimized graph shape. Ownership is clear and the team can support synchronization.

**Reasoned proposal:** evaluate a semantic primary with a derived LPG projection. Version the mapping, publish watermarks, reconcile deletions, and define acceptable lag. Keep one authority per fact. Compare the total cost against using only one store; adopt the second store only if the measured benefit justifies it.

### Case D · Question answering over unreviewed documents
The team wants answers from a large collection of course documents, but extraction quality and access controls are not yet established.

**Reasoned proposal:** begin with source registration, evidence retrieval, permissions, and a reviewed evaluation set. Introduce claim extraction and graph expansion for question classes that need relationships. Separate unreviewed extracted claims from eligibility facts. RDF versus LPG is secondary until identity, provenance, and evidence quality are reliable.
