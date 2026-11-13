# Reader guide

## Edition, authorship, and review status

### Version 0.1.0 — author review draft
**Author: Dr. Mahdi Habibi. Prepared: 13 November 2026.** This is an educational synthesis of established graph models, standards, and engineering practices. Its contribution is the teaching sequence, original running example, comparisons, and practical exercises. It does not claim a new graph algorithm or a universal performance result.

### Audience and promise
The book is for a reader beginning with graph concepts who wants to understand RDF-based semantic systems and labeled property graphs, then reason about a practical architecture. It introduces concepts before syntax and uses one learning catalog throughout. Advanced chapters explain design issues and selected techniques; they are not a complete language specification or deployment manual.

### Version and citation status
Version 0.1.0 identifies this review package. No DOI has been assigned or reserved for this book. A preliminary citation is: **Habibi, Mahdi. Knowledge Graphs: Semantic Graphs and Property Graphs. Version 0.1.0, author review draft, 2026.** Add the permanent archive identifier only after the real record exists.

### Reuse and feedback
The prepared public-release proposal is CC BY 4.0 for original text, illustrations, and synthetic data, with MIT for code. Final adoption remains pending; this draft does not claim that an open license has already been granted. The publication package contains the proposed options and metadata. Feedback should identify the section, the exact claim or confusing step, and a suggested correction or a reproducible counterexample.

The next sections explain how to study the book. Begin with the catalog story rather than trying to memorize the technology names on the cover.

## How to use this book

### The question this book answers
When should a knowledge graph use RDF and semantic standards, when should it use a labeled property graph, and what evidence makes that choice defensible? You will learn to model the same learning catalog twice, query both representations, distinguish inference from validation, and design an operational architecture.

A **knowledge graph** is a representation of entities, their relationships, and the meaning or context needed to use those relationships. There is no single universally enforced definition. This book uses the term for both semantic graphs and property graphs when they carry a coherent domain model and identifiable entities.

### Three reading routes
- **First exposure:** read Foundations, then the RDF and property-graph parts in order. You may skip the section marked Architect track on reasoning strategies and profiles until a second reading. Begin by reading and predicting examples; use the early lab instructions when ready to run them.
- **Application developer:** focus on the worked queries, recommendation example, data contracts, performance, security, and reproducibility appendix.
- **Architect or advanced reader:** add ontology semantics, loss-aware mappings, graph RAG, the decision framework, and the operational case exercises.

### A recommended study sequence
First follow Maya's story and learn how each representation records the same facts. Next read the query walkthroughs, run the small lab, and compare the results. Then revisit logical definitions and data checks, before studying mappings and system design. The references offer optional standards primers once the vocabulary is familiar; they are not prerequisites for Chapter 1.

### What you should know first
No graph background is required. A **database** stores and retrieves data. A **query** asks for data. A **schema** describes permitted or expected structure. A **transaction** groups operations into one unit of work. The next section explains our example conventions. After that, we introduce the fictional learning catalog before using its people or courses to explain graph terms. Basic familiarity with structured text is helpful.

### Edition and scope
The following version details are a reference note. On a first reading, continue with the story and return here after the languages have been introduced.

> Reading code is not evidence that a production system behaves correctly. The companion files include small RDF and Cypher exercises with scoped validation results; production deployment, concurrency, and performance require separate verification.

The executable core targets RDF 1.1, Turtle, SPARQL 1.1, OWL 2, SHACL Core, and Neo4j 5-compatible Cypher. Later syntax and deployment features are explicitly separated. RDF 1.2 Concepts was a Candidate Recommendation Snapshot dated 7 April 2026 when checked for this edition; do not assume draft features are uniformly supported. [[1](xii-references.md#ref1), [2](xii-references.md#ref2), [3](xii-references.md#ref3), [4](xii-references.md#ref4), [5](xii-references.md#ref5), [6](xii-references.md#ref6), [7](xii-references.md#ref7), [8](xii-references.md#ref8)]

All domain data, diagrams, decision scores, and scenarios are original teaching examples. No external organization is represented. Reference numbers point to primary specifications and documentation. Product behavior depends on release, configuration, and edition.

## How to follow the examples

### One story, several representations
Throughout the tutorial, we return to the same question: what can Maya study next? The learning catalog is introduced in Foundations, after the optional setup guide. We first draw its facts, introduce the two representation approaches and their vocabulary, then work through RDF in detail and later rebuild the same facts as a labeled property graph. Changing representation does not mean that Maya or the courses have changed.

Each worked example identifies its purpose and the role of its code. Read that introduction before looking at the syntax. Then follow the explanation of the result. You do not need to understand every symbol on first contact: the surrounding text explains what each group of symbols contributes.

### Know which kind of example you are reading
- **Baseline example:** uses the unchanged starting catalog and its expected answers. The companion files reproduce this dataset.
- **Isolated variation:** changes one fact to demonstrate a concept, such as a second topic. It does not silently modify later baseline examples.
- **Model extension:** adds a new kind of record, such as a completion event or evidence document. It needs additional data and sometimes new queries.
- **Schema example:** describes categories, logical meaning, or acceptance rules. A schema file is different from the file of learner and course facts.
- **Architecture pseudocode:** illustrates a sequence of responsibilities. It is not a program that can be copied into a database console.

### How to read the diagrams
Boxes represent the things or processing stages named inside them. Arrows show the stated relationship or flow. Read the arrow's text and direction together; “c2 requires c1” and “c1 is a prerequisite of c2” use opposite directions for the same requirement. Colors distinguish roles visually and do not imply extra facts.

### How to read the code
A code block may be a complete query, a short data fragment, or a pattern illustration. Its introduction tells you which. Blocks in different languages are alternatives unless we explicitly say to combine them. The complete lab files are the starting point for execution; do not concatenate every snippet in the book.

When an exercise changes a fact, start from a fresh baseline copy unless it explicitly builds on an earlier change. This keeps the expected results understandable. Later chapters broaden the story to system design, performance, and graph RAG; their opening paragraphs explain that shift.

## Running the examples

### Locate the companion files
This PDF is distributed with a companion ZIP package. Extract that ZIP and open its top-level folder. The lab is the folder named lab, beside book, scripts, publication, and README.md. The RDF data is lab/catalog.ttl; the property-graph loader is lab/catalog.cypher. No public download address has been assigned to this draft. If you received only the PDF, request the companion package from the author. You can still read every explanation and predict the printed results without installing software.

The commands below go into a terminal, not into a graph query editor. Open a terminal in the extracted lab folder. On macOS, use your terminal's New Terminal at Folder action if available, or type cd followed by a space and drag the lab folder into the terminal, then press Enter. Use a fresh copy of the lab for experiments. Python 3.10 or newer is needed for the RDF route; the Neo4j route additionally needs a working Docker installation. Installation of those tools is outside this tutorial.

### Run the RDF lab
These commands create a local Python environment, install the pinned lab dependencies, and execute the supplied checks. The .venv folder holds that environment. On Windows, replace .venv/bin/python with .venv\Scripts\python.exe.

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python check_rdf.py
```

The lab includes a starter practice.rq that lists the Graphs courses. To run another query, replace its contents with one complete query, including PREFIX declarations. The supplied run_query.py in the same folder contains the following small runner; if working from the PDF alone, save it there yourself. Graph().parse reads the data; query evaluates the file; the loop prints each result row. Rows print as readable text separated by |; an absent optional value prints (unbound). These are Python instructions, not RDF syntax.

```python
from pathlib import Path
import sys
from rdflib import Graph
root = Path(__file__).resolve().parent
data_file = sys.argv[[1](xii-references.md#ref1)] if len(sys.argv) > 1 else "catalog.ttl"
query_file = sys.argv[[2](xii-references.md#ref2)] if len(sys.argv) > 2 else "practice.rq"
graph = Graph().parse(root / data_file, format="turtle")
query = (root / query_file).read_text()
for row in graph.query(query):
    print(*(str(v) if v is not None else "(unbound)" for v in row),
          sep=" | ")
```

Run .venv/bin/python run_query.py after saving each query. For a data variation, copy catalog.ttl to practice.ttl and run .venv/bin/python run_query.py practice.ttl. Append the exercise's triple to that copy, including the final period; rerun that command. No Python edit is needed. A second optional argument selects a different query file: .venv/bin/python run_query.py practice.ttl 01_graph_courses.rq. Restore practice.ttl from catalog.ttl before a different variation. Do not add extension facts to the authoritative baseline or assume a SELECT query changes stored data.

### Open a Cypher console
In the lab terminal, start a dedicated exercise container using the following command. It publishes no database ports and mounts no host data. Never substitute an existing database for this exercise. Authentication is disabled only for this disposable, unexposed container. Wait for the log to say Started, then open the console. If the name already exists, use a different exercise name consistently; do not remove an unfamiliar container.

```sh
docker run -d --name kg-book-lab --hostname localhost --memory=2g \
  -e NEO4J_AUTH=none \
  -e NEO4J_server_memory_heap_initial__size=256m \
  -e NEO4J_server_memory_heap_max__size=512m \
  -e NEO4J_server_memory_pagecache_size=128m \
  neo4j:5.26.30
docker logs --tail 12 kg-book-lab
docker exec -it kg-book-lab cypher-shell
```

For a manual load on macOS or Linux, leave the console with :exit and run docker exec -i kg-book-lab cypher-shell < catalog.cypher from the lab terminal. This sends the complete loader file to the exercise database. Reopen the console with docker exec -it kg-book-lab cypher-shell to run queries. Alternatively, paste the file's statements into that console, including each final semicolon; this also works when your terminal does not support the shown file-redirection syntax. Load the complete file before running read queries. To set the duration parameter, enter :param maxMinutes => 75 before the duration query. Type :exit to leave the console. The Python command python3 check_cypher.py --container kg-book-lab is an alternative automated route, but it requires an empty graph: do not run it after manually loading the catalog.

Use the console for the short exercise variations and their cleanup statements. When finished, remove only this exercise container and its anonymous volumes using docker rm -fv kg-book-lab. Chapter 10 gives the full lab scope and expected-results checklist.

### A notation card to return to
These symbols will be explained again immediately before their first use. The same punctuation can mean different things in different languages.

| Language | Symbol | First reading |
|---|---|---|
| Turtle | ex:c1 / a | Abbreviated resource IRI / rdf:type |
| Turtle | ; / , / . | Same subject / same subject and predicate / end group |
| Turtle | ^^ / @en | Datatype marker / English language tag |
| SPARQL | ?course / PREFIX | Query variable / IRI abbreviation declaration |
| Cypher | (c:Course) | A node, query variable c, label Course |
| Cypher | -[:REQUIRES]-> | A directed relationship of type REQUIRES |
| Cypher | {id: 'c1'} / $maxMinutes | Property map / separately supplied parameter |

