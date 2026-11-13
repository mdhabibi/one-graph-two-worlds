# Synthetic learning catalog lab

The baseline contains 4 courses, 2 people, 3 topics, and 10 LPG relationships.
All people and events are fictional. Keep each isolated variation separate.

## RDF route

From this directory, using Python 3.10 or newer:

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python check_rdf.py
```

On Windows use `.venv\Scripts\python` in place of `.venv/bin/python`.
The checker uses RDFLib in memory. It does not deploy a triplestore or SPARQL
server. It checks six queries, baseline and negative SHACL cases, policy
changes, malformed-input cases, subclass targeting, and a small RDFS inference. The basic checker parses the OWL file; the separate optional owl_dl checker
uses HermiT for targeted DL profile, consistency and entailment checks.

## Neo4j route

Docker must already be available. Use an empty dedicated exercise container;
no host data folders or externally published database ports are needed:

```sh
docker run -d --name kg-book-lab --hostname localhost --memory=2g \
  -e NEO4J_AUTH=none \
  -e NEO4J_server_memory_heap_initial__size=256m \
  -e NEO4J_server_memory_heap_max__size=512m \
  -e NEO4J_server_memory_pagecache_size=128m \
  neo4j:5.26.30
python3 check_cypher.py --container kg-book-lab
```

These examples use normal container networking and expose no database ports.
The checker connects from inside the container using cypher-shell. Authentication
is disabled only for this disposable, unexposed exercise database. If you choose
to publish a port or deploy a service, configure authentication and access controls.

The checker refuses a nonempty graph before loading. It runs the loader twice,
executes the five published query blocks verbatim (supplying maxMinutes=75),
checks named policy changes and malformed-input counterexamples, and restores
the baseline. Missing ids/titles and untyped prerequisite targets exclude c2.
A title list remains one LPG value, unlike multiple RDF title solutions; it is
outside the scalar-title contract.
Afterward, remove only this exercise container and its anonymous test volumes:

```sh
docker rm -fv kg-book-lab
```

The same checks passed locally against Neo4j Community 5.26.30 on 13 November
2026. This is not a concurrency, recovery, performance, or broader version-matrix
claim. If you have a different release, rerun rather than assuming compatibility.

## Expected results

| Question | Answer |
|---|---|
| Courses about Graphs | c1, c2 |
| Courses at most 75 minutes | c1, c3, c4 |
| Distinct courses by topic | graphs 2, data 1, ethics 1 |
| Prerequisite reachable from c2 | c1 |
| Maya's recommendation | c2 / Graph Search |

The complete data files are catalog.ttl and catalog.cypher. The models use
stable IDs and treat all recorded prerequisites conjunctively. Event and evidence
snippets in the book are extensions, not unannounced baseline records.

The latest cases retain an untyped shared topic but require the learner's Person
category in both query languages. Removing it excludes the learner, and SHACL
rejects the corresponding submitted graph. The labeled Cypher anchor uses the
Person.id uniqueness index. The checker saves labeled/unlabeled EXPLAIN plans
alongside its report; these plans are fixture evidence, not latency benchmarks.

## Beginner practice

The reader guide includes early setup and a console walkthrough. Save one
complete SPARQL query as practice.rq in lab, then run the supplied run_query.py
with the lab Python environment. The starter practice.rq is included. For variations,
copy catalog.ttl to practice.ttl and use run_query.py practice.ttl; no Python edit
is required. A second argument selects a query file. Output uses readable |
separators and (unbound) for absent bindings. The practice_queries.rq and
practice_queries.cypher files each contain three separate solution blocks:
Leo's recommendation, Maya's completions, and topic counts excluding Ethics.
Run one block at a time; do not parse the combined SPARQL file as one query.

For manual loading from a macOS/Linux lab terminal, use:

```sh
docker exec -i kg-book-lab cypher-shell < catalog.cypher
docker exec -it kg-book-lab cypher-shell
```

This manual route is separate from check_cypher.py, which requires an empty graph.

See [owl_dl/README.md](owl_dl/README.md) for the Graduate and Exercise 5 reasoner checks.
