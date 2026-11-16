# III · Querying RDF

## 3.1 SPARQL patterns and variable bindings

> **Learning goals for this part:** Trace variable bindings, optional matches, paths, and duplicate rows; reproduce the baseline outputs; explain the completeness assumptions behind eligibility.

The baseline RDF file is ready, and we know how definitions and quality rules differ from facts. We can now ask our first data question: which courses are about Graphs? The query below reads the unchanged baseline; it does not insert facts or require OWL reasoning.

### Match a small piece of the graph
To execute the following queries, use Running the examples in the reader guide: save the complete query as lab/practice.rq and run the small Python runner there. SPARQL PREFIX declares the same IRI abbreviation as Turtle @prefix, but uses no @ sign and no ending period.

**SPARQL** is a query language and related protocol family for RDF. A **triple pattern** resembles an RDF triple but can contain variables. A **variable binding** assigns an RDF term to a variable for one solution. A **basic graph pattern** combines triple patterns by their shared variables. A **projection** selects which variables appear in the output. [[4](xii-references.md#ref4)]

**Baseline query — which courses are about Graphs?** The variable `?course` will stand for a matching course, while `?id` and `?title` collect the two values we want to show. The WHERE block describes the facts that must match; SELECT chooses the output columns.

```sparql
PREFIX ex: <https://example.org/>
SELECT ?id ?title
WHERE {
  ?course a ex:Course ;
          ex:id ?id ;
          ex:title ?title ;
          ex:about ex:graphs .
}
ORDER BY ?id
```

For the baseline catalog, this returns `c1 / Graph Basics` and `c2 / Graph Search`. The variable `?course` binds to each matching course resource but is omitted from the output. Shared occurrences of a variable must agree within a solution. That agreement is the join condition.

### Trace the query manually
First find resources with type Course. Restrict them to resources connected by about to Graphs. Read each matching id and title. The logical reading is useful even if the query planner evaluates patterns in a different order. A **query planner** selects a physical execution strategy; declarative queries specify the answer rather than an imperative traversal program.

### Four useful query forms
`SELECT` produces solution bindings. `ASK` produces a boolean indicating whether a solution exists. `CONSTRUCT` builds an RDF graph from matched solutions. `DESCRIBE` requests a resource description whose exact content depends on the service. Use CONSTRUCT when you need a predictable graph shape. [[4](xii-references.md#ref4)]

**Baseline yes/no query — did Maya complete c1?** This independent ASK query checks one recorded connection and does not change the data.

```sparql
PREFIX ex: <https://example.org/>
ASK { ex:maya ex:completed ex:c1 }
```

Expected result: true. Without additional reasoning, this asks about the explicitly available query dataset. It is not a general proof about every possible external source.

## 3.2 Walk through one query, row by row

### From a question to a result table
We have just asked which courses are about Graphs. Before adding more syntax, trace how the first SELECT query can be understood by a reader. We use the unchanged catalog and the same patterns; the following stages explain the logic, not a promise about the engine's physical execution order.

### Stage 1: find courses
The pattern `?course a ex:Course` permits the course variable to match c1, c2, c3, or c4. Each possibility begins a solution. Think of a working table whose course column contains one of those identifiers. At this stage, a course being a candidate does not mean that it is a recommendation for Maya.

### Stage 2: require the Graphs topic
The pattern `?course ex:about ex:graphs` uses the same course variable. Its value must agree with the value already used in that solution. c1 and c2 have the required topic, so they remain; c3 and c4 do not. This shared variable connects the patterns. The engine does not choose an unrelated course independently for the second pattern.

### Stage 3: retrieve values from those same courses
The id and title patterns bind the selected courses' display values. For c1 they bind id to the string c1 and title to Graph Basics; for c2 they bind c2 and Graph Search. A variable binding is part of one solution, not a permanent rename of a graph node.

### Stage 4: show only the requested columns
SELECT asks for id and title. The internal course binding helps find them but is not itself an output column in this query. ORDER BY places c1 before c2. Without an ordering clause, a particular display order should not become part of the expected contract.

**Table — logical checkpoints after all four stages.**

| Logical checkpoint | Remaining course possibilities | Why |
|---|---|---|
| Match Course type | c1, c2, c3, c4 | Four explicit Course instances |
| Also match about Graphs | c1, c2 | Both patterns must agree on the course |
| Retrieve id and title | c1 / Graph Basics; c2 / Graph Search | Read values on those same resources |
| Project and order | Two rows, ordered by id | SELECT chooses columns; ORDER BY chooses presentation |

### Predict a change before running it
**Isolated variation:** if c3 also becomes about Graphs, it joins the answer because it now satisfies the topic pattern. **Different variation:** if we delete c2's title, the original query omits c2 because its title pattern is mandatory. Neither change has been applied to the baseline files.

This explains the next section's need: how can we keep a course even when optional information is absent, and what happens when several facts satisfy a pattern? The answer requires controlling which patterns are mandatory and understanding repeated solutions.

## 3.3 Optional data, filters, and duplicate results

Our first query required every requested fact to be present. Real catalogs often omit descriptions or give a course several topics. We now keep the same baseline and study how those situations affect query rows, so missing data and repeated answers do not become surprises.

### Preserve a course even when an attribute is absent
`OPTIONAL` adds matching bindings when available and preserves the current solution when the optional pattern has no match. An **unbound variable** has no RDF term assigned in that solution. It is not an RDF literal called null. [[4](xii-references.md#ref4)]

**Baseline query — list all courses, with a summary if one exists.** We deliberately have no summary facts in catalog.ttl. The point is to retain a course even when its optional description is absent.

```sparql
PREFIX ex: <https://example.org/>
SELECT ?id ?title ?summary
WHERE {
  ?c a ex:Course ; ex:id ?id ; ex:title ?title .
  OPTIONAL { ?c ex:summary ?summary }
}
ORDER BY ?id
```

All four baseline courses appear; `?summary` is unbound for all of them. If one course has several summary values, it can generate several rows. A **multiset**, or bag, permits duplicate solutions; query results can be multisets even though an RDF graph is a set of triples.

### Filter placement changes the question
A `FILTER` restricts solutions according to an expression. A numeric filter such as `FILTER(?minutes <= 75)` requires a suitable bound numeric value. If an optional variable remains unbound, many expressions involving it produce an error that fails the filter. Use `BOUND` or `COALESCE` deliberately when missing values should be retained or replaced.

**Baseline expression example — keep missing summaries visible.** BOUND reports whether a variable has a value. COALESCE uses its first expression that evaluates without an error, so an unbound summary falls back to the text No summary.

```sparql
PREFIX ex: <https://example.org/>
SELECT ?id (BOUND(?summary) AS ?hasSummary)
       (COALESCE(?summary, "No summary") AS ?shown)
WHERE {
  ?c a ex:Course ; ex:id ?id .
  OPTIONAL { ?c ex:summary ?summary }
}
ORDER BY ?id
```

All four baseline rows show false and No summary. These are display results, not new triples inserted into the graph. This example does not turn an unknown factual value into a known one.

**Baseline query — find courses about Graphs or Data.** This separate query asks for distinct course IDs. The later exercise adds an extra topic to demonstrate why DISTINCT matters.

```sparql
PREFIX ex: <https://example.org/>
SELECT DISTINCT ?id
WHERE {
  ?c a ex:Course ; ex:id ?id ; ex:about ?topic .
  FILTER(?topic IN (ex:graphs, ex:data))
}
ORDER BY ?id
```

IN lists the allowed topic terms: a solution survives if its topic equals Graphs or Data. Expected IDs: c1, c2, c3. `DISTINCT` removes duplicate projected solutions. It does not fix a mistaken model or a join that combined unrelated records. When counting, decide whether you mean courses, topics, events, or solution rows.

**Exercise:** in practice.ttl, a fresh copy of catalog.ttl, append ex:c2 ex:about ex:data . and rerun this query with the reader-guide runner. Restore the copy afterward. Without DISTINCT, c2 matches twice. With DISTINCT, it appears once because the selected ID is identical across both solutions.

## 3.4 Paths, aggregation, and graph construction

The earlier queries returned course attributes. We now ask three different questions about the same baseline: which prerequisites are reachable, how many courses cover each topic, and how to return a new graph of candidate links. Each block is an independent query, not a step that modifies the next block.

### Reachability is different from enumerating routes
A SPARQL **property path** expresses a sequence or repetition of predicates. `ex:requires+` means one or more requires steps; `ex:requires*` also permits zero steps. A zero-length path can relate a node to itself. A path expression asks about connections; it does not generally return every intermediate node or every distinct route. [[4](xii-references.md#ref4)]

**Baseline query — what does c2 require, directly or indirectly?** Start at c2, follow one or more requires connections, and return each reachable required course.

```sparql
PREFIX ex: <https://example.org/>
SELECT ?required
WHERE { ex:c2 ex:requires+ ?required }
```

The baseline answer is `ex:c1`. If c1 requires an introductory course c0, c0 becomes reachable too. Cycles require attention: a cycle can make a course reachable from itself through a positive-length path. A prerequisite system usually needs a cycle-quality check, not merely a reachability query.

### Aggregate after choosing the unit
**Aggregation** summarizes grouped solutions. `GROUP BY` defines groups; `COUNT` counts solutions or bound values, and `COUNT(DISTINCT ?c)` counts distinct course terms.

**Baseline query — how many distinct courses cover each topic?** Here each result row summarizes a topic rather than describing one course.

```sparql
PREFIX ex: <https://example.org/>
SELECT ?topic (COUNT(DISTINCT ?c) AS ?courses)
WHERE { ?c a ex:Course ; ex:about ?topic }
GROUP BY ?topic
ORDER BY DESC(?courses) ?topic
```

Baseline topic terms and counts: ex:graphs 2, ex:data 1, ex:ethics 1. The topic bindings are full IRIs; ex: is shorthand here. The parentheses around COUNT define a computed output expression; AS names its output variable courses. DESC orders larger counts first. A secondary ordering makes tied results predictable. Always define ordering before relying on a user-visible top-k result.

### Return a graph of candidate links
**Baseline query — construct candidate links for Maya.** This creates a returned RDF graph of topic-matching, uncompleted courses. CONSTRUCT returns that graph; it does not insert it into storage. This simplified candidate query does not yet check prerequisites.

```sparql
PREFIX ex: <https://example.org/>
CONSTRUCT { ex:maya ex:mayStudy ?c }
WHERE {
  ex:maya ex:likesTopic ?t .
  ?c a ex:Course ; ex:about ?t .
  FILTER NOT EXISTS { ex:maya ex:completed ?c }
}
```

This constructs `ex:maya ex:mayStudy ex:c2` for the baseline. It only applies topic and completion conditions; prerequisite completeness is added in the next section. Treat `mayStudy` here as a query output predicate, not an unqualified eligibility guarantee.

## 3.5 A policy-aware recommendation query

We can now combine topic matching and absence tests to answer Maya's original question. This query implements the policy introduced with the catalog. Read its three conditions in order, then trace why c2 survives while the other courses do not.

### Define the policy before writing the query
Maya is a candidate for a course if it matches an explicitly liked topic, she has no recorded completion for it, and there is no recorded prerequisite that she lacks. The final condition is a **universal condition** expressed through the absence of a counterexample: every prerequisite is satisfied if no unsatisfied prerequisite exists.

**Baseline query — recommend Maya's eligible next course.** The first pattern requires Maya to be explicitly typed Person and reads her liked topics. The next patterns find matching Course records with id and title. The first NOT EXISTS excludes completed courses; the nested NOT EXISTS excludes a candidate if any recorded prerequisite is unmet.

```sparql
PREFIX ex: <https://example.org/>
SELECT DISTINCT ?id ?title
WHERE {
  ex:maya a ex:Person ; ex:likesTopic ?topic .
  ?c a ex:Course ; ex:id ?id ; ex:title ?title ;
     ex:about ?topic .
  FILTER NOT EXISTS { ex:maya ex:completed ?c }
  FILTER NOT EXISTS {
    ?c ex:requires ?required .
    FILTER NOT EXISTS { ex:maya ex:completed ?required }
  }
}
ORDER BY ?id
```

Expected result: `c2 / Graph Search`. The first NOT EXISTS excludes c1. The nested condition checks c2's required course c1, finds Maya's completion, and therefore finds no unmet prerequisite. c3 and c4 fail the topic preference condition.

### Read the scope carefully
`NOT EXISTS` is evaluated relative to the outer bindings and active dataset. It implements a dataset-level test, not an OWL negative assertion. This query is sound for the declared policy only if the selected catalog contains all prerequisites relevant to the decision and the completion records are sufficiently complete for the user. [[4](xii-references.md#ref4)]

A course with no recorded prerequisites passes the final test. This is **vacuous truth**: there is no prerequisite counterexample. If “unknown prerequisites” must be treated differently from “none required,” add an explicit review or completeness field and filter on it.

### Eligibility is not personal suitability
Returning c2 means it satisfies the example's recorded topic, completion and prerequisite rules. It does not establish that Graph Search fits Maya's current goals, available time or circumstances. Two learners with identical query-visible records can differ in relevant conditions the graph does not contain. A relevance score or a valid path does not fill that evidence gap.

An application making a suitability claim must define the additional criteria with the relevant domain owners and learners, collect appropriate evidence, and evaluate the assessment beyond reproducing its own rules. Evidence can be stored in either graph model; its credibility and independence concern how it was obtained and assessed. Self-reported availability can be useful context without being an independently validated assessment. This tutorial establishes no universal suitability test.

When required evidence is absent, report “eligible under the recorded catalog policy; suitability not assessed.” Withhold the unsupported claim, not necessarily every helpful candidate suggestion. Ask for the missing context when appropriate. Missing evidence is not a finding that the course is unsuitable. Chapter 8 carries this boundary into generated explanations.

### Beyond a binary decision
A **ranking function** assigns scores to candidates. Keep eligibility separate from ranking. The example uses eligibility rules only; it does not learn user preference or optimize a statistical model. A production recommender might rank eligible courses by topic fit, recency, course quality, and diversity, then log the reason and evidence used for each recommendation.

The precise cross-representation alignment contract is developed in Section 10.3; baseline agreement alone is not a general equivalence guarantee.

## 3.6 Named graphs, updates, and federation

So far, each query read one local baseline graph. We now step outside that exercise to show how a larger RDF service can separate source contexts, publish changes, and consult another endpoint. The following named-graph examples need additional dataset setup and are not baseline queries.

### Organize context explicitly
Use named graphs to separate source snapshots, assertion sets, or publishing stages. **Provenance** records origin and transformation history. A graph name can be a handle for provenance, but the meaning of that association is an application convention. Query default graphs and union graphs vary by service configuration; document the chosen dataset. [[1](xii-references.md#ref1)]

**Dataset extension — inspect source context.** This query asks which named graph supplies a title for c2. It needs a dataset with named-graph content; loading the baseline Turtle into the default graph alone is not enough.

```sparql
PREFIX ex: <https://example.org/>
SELECT ?g ?title
WHERE { GRAPH ?g { ex:c2 ex:title ?title } }
```

The baseline Turtle file uses one graph, so this named-graph query needs a dataset loaded with named graphs before it has useful results. This is an architectural example, separate from the baseline queries.

### Update a specific graph
**Independent update example — publish a review flag.** The IRI ex:catalog-v1 names a graph in this example. The operation inserts a reviewed flag there; it does not populate that graph with the full baseline.

```sparql
PREFIX ex: <https://example.org/>
INSERT DATA {
  GRAPH ex:catalog-v1 { ex:c2 ex:reviewed true }
}
```

SPARQL Update provides data modification operations, including insert, delete, and graph-management operations. A service can separate query and update endpoints or restrict update access. Transaction boundaries, isolation, and durability remain implementation concerns rather than promises inferred from the RDF model. [[18](xii-references.md#ref18)]

### Query across services
A **federated query** combines information from multiple query services. SPARQL `SERVICE` evaluates a pattern at another endpoint. It can support integration without copying every source into one database, but network latency, permissions, timeouts, and inconsistent snapshot times complicate the result. Restrict service destinations; do not let untrusted users direct server-side requests to arbitrary network locations. [[19](xii-references.md#ref19)]

**Architectural test:** if one source is unavailable, should the application fail, return partial results with a warning, or use a cached snapshot? Define that policy before relying on federation for a user-facing eligibility decision. Standard syntax makes the query expressible; it does not make every dependency equally reliable.

### Connection to the next part
This completes the RDF query route. Next we return to the unchanged catalog and rebuild it with labeled nodes, typed relationships, properties, and Cypher. The domain question remains the same.

### Write a query before reading the solutions
Use the unchanged baseline and the reader-guide setup. These three tasks build on syntax already shown. Write and save your own query first, then compare it with the solutions below. The matching practice_queries file in lab contains the solutions as separate blocks; run one block at a time.
1. Recommend courses for Leo using the full policy. Expected: c3 / Query Patterns.
2. List the courses Maya completed, showing id and title. Expected: c1 / Graph Basics.
3. Count distinct courses per topic but exclude Ethics. Expected: Graphs 2 and Data 1, using the topic terms of this representation.

### Practice solutions — compare after trying
**Solution 1.** Only the learner changes in the eligibility query; Leo likes Data and completed c1.

```sparql
PREFIX ex: <https://example.org/>
SELECT DISTINCT ?id ?title
WHERE {
  ex:leo a ex:Person ; ex:likesTopic ?topic .
  ?c a ex:Course ; ex:id ?id ; ex:title ?title ;
     ex:about ?topic .
  FILTER NOT EXISTS { ex:leo ex:completed ?c }
  FILTER NOT EXISTS {
    ?c ex:requires ?required .
    FILTER NOT EXISTS { ex:leo ex:completed ?required }
  }
}
ORDER BY ?id
```

**Solution 2.** Follow the recorded completion from Maya, then read that course's display fields.

```sparql
PREFIX ex: <https://example.org/>
SELECT ?id ?title
WHERE {
  ex:maya ex:completed ?course .
  ?course a ex:Course ; ex:id ?id ; ex:title ?title .
}
ORDER BY ?id
```

**Solution 3.** Filter Ethics before grouping; the remaining groups count distinct course entities.

```sparql
PREFIX ex: <https://example.org/>
SELECT ?topic (COUNT(DISTINCT ?course) AS ?courses)
WHERE {
  ?course a ex:Course ; ex:about ?topic .
  FILTER(?topic != ex:ethics)
}
GROUP BY ?topic
ORDER BY DESC(?courses) ?topic
```

### Check your understanding
**Try first:** core questions for this chapter are 1, 6, 8, 10, 15–17, 23, 24. They cover its main concepts and application decision. Attempt the remaining questions as a second pass. Cover the next answer with a sheet or scroll it out of view while writing your prediction. Compare the explanation only after committing an answer.

This review follows the query chapter from matching facts to making a policy decision. Unless a question explicitly introduces a variation, use the unchanged baseline: c1 and c2 are about Graphs, c3 is about Data, c4 is about Ethics, and Maya likes Graphs and has completed c1. c2 and c3 each require c1. Predict the result before reading the explanation. The questions use patterns already introduced; they do not require a new dataset or service.

### Review 1 · Read patterns and result rows
**Question 1: What is the difference between a triple pattern and a variable binding?**

**Answer:** A triple pattern describes a statement to match and can contain variables, such as a variable for the course in a course-about-Graphs statement. A variable binding assigns a particular RDF term to a variable in one solution. The same course variable can therefore be bound to c1 in one solution and c2 in another. The variable's name is part of the query, not a permanent identifier stored on the course.

**Question 2: Why must repeated occurrences of the same variable agree? What could go wrong if the title pattern used a different course variable?**

**Answer:** Repeating a variable connects patterns through the same RDF term within a solution. If the topic pattern and title pattern both use the same course variable, the returned title belongs to that matched course. Using an unrelated variable for the title can combine the topic-matching course with titles of other courses. A query can be syntactically valid and still answer the wrong question because its joins do not connect the intended entities.

**Question 3: What do WHERE and SELECT contribute to the first course query? Must every matched variable appear in the result?**

**Answer:** WHERE describes the patterns that solutions must satisfy. SELECT chooses the variables to display, a step called projection. The first query matches a course resource but displays only its id and title. A variable can connect patterns internally without becoming an output column. Omitting the course variable from SELECT does not stop it from participating in the match.

**Question 4: What does the first baseline query return, and does its row-by-row explanation dictate the engine's execution order?**

**Answer:** It returns c1 / Graph Basics and c2 / Graph Search, ordered by id, because those are the Course resources about Graphs with the requested fields. The chapter's stages explain the logical conditions. A query planner may evaluate those conditions in a different physical order while preserving the specified result. Declarative syntax states the desired answers rather than a mandatory traversal procedure.

**Question 5: How do SELECT, ASK, CONSTRUCT, and DESCRIBE differ?**

**Answer:** SELECT returns solution bindings; ASK reports whether at least one solution exists; CONSTRUCT returns an RDF graph built from a template and matching solutions. DESCRIBE requests descriptions whose exact content depends on the service. Use CONSTRUCT when a predictable returned graph structure is required. Neither a returned table nor a returned graph is automatically a change to stored data.

### Review 2 · Handle missing values and repeated solutions
**Question 6: The baseline has no course summaries. Why does the OPTIONAL summary query still return all four courses?**

**Answer:** The required patterns first match each course's type, id, and title. OPTIONAL attempts to add a summary binding but preserves the existing solution if no summary matches. Each course therefore remains, with its summary variable unbound. An unbound variable has no RDF term assigned in that solution; it is not a literal value called null and does not create a missing-value triple in the graph.

**Question 7: What happens if a filter outside the optional block compares an unbound numeric variable with 75?**

**Answer:** An ordinary numeric comparison on an unbound variable produces an expression error, so that solution fails the filter. The course can disappear even though OPTIONAL initially preserved it. Decide the intended missing-value policy and express it deliberately, using tools such as BOUND or COALESCE where appropriate. Keeping an incomplete record and treating its missing value as a particular number are different decisions.

**Question 8: RDF graphs are sets of triples. How can a query still produce repeated course IDs?**

**Answer:** Different matching combinations can produce separate solutions that become identical after projection. In the isolated variation where c2 is about both Graphs and Data, the Graphs-or-Data query matches c2 once through each topic. If only its id is selected, c2 appears twice without DISTINCT. The repeated rows come from two matches, not from storing an identical triple twice.

**Question 9: In that two-topic variation, what does SELECT DISTINCT ?id remove? Would it also collapse rows if both id and topic were selected?**

**Answer:** Selecting only distinct ids collapses c2's identical projected id rows into one. If both id and topic are selected, the c2/Graphs row differs from the c2/Data row, so DISTINCT retains both. DISTINCT compares the projected solutions, not an implicit notion of one row per course. It also cannot repair an incorrect join or decide which facts should belong in the model.

### Review 3 · Trace paths, counts, and returned graphs
**Question 10: What is the difference between requires+ and requires*? What does the baseline query starting from c2 return?**

**Answer:** The plus form follows one or more requires steps; the star form also permits zero steps, which can connect a starting resource to itself. In the baseline, following requires+ from c2 reaches c1. If an isolated extension adds a prerequisite from c1 to c0, c0 becomes reachable too. These expressions answer reachability questions; they do not generally display every intermediate node or enumerate every distinct route.

**Question 11: Can requires+ return c2 itself? Would that necessarily mean the query syntax is wrong?**

**Answer:** Yes, if a positive-length prerequisite cycle leads back to c2. That is a consequence of the recorded connections, not automatically a syntax error. A catalog that forbids prerequisite cycles needs a quality check and a defined response to violations. Replacing a path expression does not, by itself, repair contradictory course requirements.

**Question 12: What does COUNT(DISTINCT ?c) count in the topic query, and what are the baseline counts?**

**Answer:** It counts distinct bound course resources within each topic group. The baseline gives Graphs 2, Data 1, and Ethics 1. Counting solution rows instead can overcount courses if additional patterns create multiple solutions per course. Define whether the requested unit is a course, a topic association, an event, or a result row before choosing an aggregate.

**Question 13: Why is a secondary ordering useful, and does ORDER BY alone rank courses by recommendation quality?**

**Answer:** A secondary key makes the order of tied primary values predictable when that key distinguishes the tied results. In the topic-count query, ordering by topic after the count stabilizes the Data/Ethics tie. Ordering course IDs merely arranges output; it does not supply a preference model or quality score. A ranking function must state how eligible candidates are scored, and any top-k selection needs a deliberate ordering policy.

**Question 14: The candidate CONSTRUCT query returns a mayStudy link to c2. Has it stored that link or established the full prerequisite policy?**

**Answer:** Neither. CONSTRUCT returns a graph; it does not insert the constructed triples into storage. That simplified query checks topic matching and the absence of a recorded completion, but not prerequisites. c2 happens to be the correct full-policy result in the baseline because its prerequisite is satisfied. The same output in this small case does not make the simplified and full-policy queries equivalent for every catalog.

### Review 4 · Explain the recommendation policy
**Question 15: How does the nested NOT EXISTS test express “every recorded prerequisite is satisfied”?**

**Answer:** Read it from the inside outward. For each recorded prerequisite of a candidate, the inner absence test asks whether Maya lacks a recorded completion for that prerequisite. Such a match is an unmet-prerequisite counterexample. The outer absence test keeps the candidate only if no counterexample exists. This implements a universal condition over the selected recorded data; it is not an assertion that the system knows every fact in the world.

**Question 16: Trace the baseline decision for c2 and distinguish it from the exclusions of c1, c3, and c4.**

**Answer:** c2 matches Maya's Graphs interest and has no recorded completion by Maya. Its prerequisite is c1, and Maya has a completion for c1, so there is no unmet-prerequisite counterexample. c1 is excluded because Maya completed it. c3 and c4 do not match her recorded interest. Different candidates fail different conditions; an explanation should identify the actual facts and policy condition involved.

**Question 17: A candidate has no recorded prerequisites. Why does it pass the prerequisite test, and when is that unsafe as an interpretation?**

**Answer:** There is no recorded prerequisite that can be an unmet counterexample, so the condition passes. This is vacuous truth. It does not establish that someone reviewed the course and confirmed that none are required. If an unreviewed prerequisite list must differ from a confirmed empty list, represent that distinction explicitly, for example with a completeness or review field, and include it in the policy.

**Question 18: Why can the prerequisite absence test change after a catalog update?**

**Answer:** It is a policy over the selected recorded graph. In an isolated variation, add c3 as a prerequisite of c2 while Maya still has no recorded completion for c3. That new connection supplies an unmet-prerequisite counterexample, so c2 stops passing the full recommendation query. Recording Maya's completion of c3 would remove that counterexample. The changed result is expected: an absence-based decision can be withdrawn when new data arrives.

**Question 19: Does NOT EXISTS prove an OWL negative assertion, and must this chapter's query check all transitively reachable prerequisites?**

**Answer:** No to both. NOT EXISTS tests for matching solutions relative to the current bindings and active dataset; it is not an OWL statement that a relationship is false. The recommendation query matches direct requires statements, whereas requires+ was a separate reachability example. If the policy needs every prerequisite in the transitive chain, revise the query and its tests deliberately, and decide how cycles and incomplete records are handled. Do not silently give the direct-prerequisite query a stronger meaning.

### Review 5 · Identify the dataset and service boundary
**Question 20: Why can the GRAPH ?g title query return nothing when the ordinary title query finds c2?**

**Answer:** The GRAPH pattern searches named graphs in the query dataset. Loading the baseline Turtle only into the default graph does not populate those named graphs. The absence of a named-graph match therefore does not mean the course title is absent everywhere. Confirm which graphs were loaded and which dataset the endpoint exposes. A graph name can support a provenance convention, but does not authenticate its contents on its own.

**Question 21: Does inserting a reviewed flag into catalog-v1 copy the full catalog there or guarantee a durable transaction?**

**Answer:** No. The independent INSERT DATA example adds the stated flag triple to the named graph; it does not copy unrelated course facts. Update access and operational guarantees depend on the service and database configuration, including permissions, transaction boundaries, isolation, and durability. Distinguish a valid update statement from evidence that a deployed system has the required operational behavior.

**Question 22: A federated prerequisite service is unavailable. Should the application treat the missing response as proof that no prerequisites exist?**

**Answer:** No. Failure to obtain a source response is different from successfully querying a complete source and finding no matching facts. The architecture must define whether to stop the decision, use a suitable cached snapshot, or return an explicitly qualified partial result. SERVICE provides remote query capability, not automatic reliability or synchronized snapshots. Record the sources and snapshot context used when an eligibility decision depends on them.

### Apply the chapter to a changed catalog
**Question 23: In an isolated variation, c2 also gains the Data topic and a new unmet prerequisite c3. Maya's interests and completions stay unchanged. What should the two relevant queries return?**

**Answer:** The Graphs-or-Data query without DISTINCT produces c1 once, c2 twice, and c3 once; selecting DISTINCT ids reduces that to c1, c2, and c3. The full recommendation query returns no eligible course for Maya: c2 is still a topic match but now has the unmet prerequisite c3, c1 is already completed, and c3 and c4 still do not match her interest. One variation affects row multiplicity and another affects eligibility. Restore the baseline after the exercise so later examples keep their stated expected answers.

### Review 6 · Limit the claim to the evidence
**Question 24: Can two learners receive the same policy result while differing in personal suitability?**

**Answer:** Yes. The query can see identical relevant records while goals, available time or circumstances differ. Its answer establishes only satisfaction of the stated policy under its data assumptions. Define and evaluate the additional criteria before claiming suitability. If the required evidence is absent, label suitability as not assessed; that does not imply either suitability or unsuitability.

**Ready to continue:** You should be able to trace shared variables, predict optional and duplicate results, distinguish a returned graph from an update, and explain a recommendation through its recorded evidence and policy assumptions. The next part rebuilds the same baseline in Neo4j and Cypher; a change of representation does not change Maya's starting facts.

