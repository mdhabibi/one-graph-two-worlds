# Knowledge Graphs: Semantic Graphs and Property Graphs
Dr. Mahdi Habibi · Independent educational edition · 13 November 2026

=== Reader guide | Edition, authorship, and review status
### Version 0.1.0 — author review draft
**Author: Dr. Mahdi Habibi. Prepared: 13 November 2026.** This is an educational synthesis of established graph models, standards, and engineering practices. Its contribution is the teaching sequence, original running example, comparisons, and practical exercises. It does not claim a new graph algorithm or a universal performance result.

### Audience and promise
The book is for a reader beginning with graph concepts who wants to understand RDF-based semantic systems and labeled property graphs, then reason about a practical architecture. It introduces concepts before syntax and uses one learning catalog throughout. Advanced chapters explain design issues and selected techniques; they are not a complete language specification or deployment manual.

### Version and citation status
Version 0.1.0 identifies this review package. No DOI has been assigned or reserved for this book. A preliminary citation is: **Habibi, Mahdi. Knowledge Graphs: Semantic Graphs and Property Graphs. Version 0.1.0, author review draft, 2026.** Add the permanent archive identifier only after the real record exists.

### Reuse and feedback
The prepared public-release proposal is CC BY 4.0 for original text, illustrations, and synthetic data, with MIT for code. Final adoption remains pending; this draft does not claim that an open license has already been granted. The publication package contains the proposed options and metadata. Feedback should identify the section, the exact claim or confusing step, and a suggested correction or a reproducible counterexample.

The next sections explain how to study the book. Begin with the catalog story rather than trying to memorize the technology names on the cover.

=== Reader guide | How to use this book
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

The executable core targets RDF 1.1, Turtle, SPARQL 1.1, OWL 2, SHACL Core, and Neo4j 5-compatible Cypher. Later syntax and deployment features are explicitly separated. RDF 1.2 Concepts was a Candidate Recommendation Snapshot dated 7 April 2026 when checked for this edition; do not assume draft features are uniformly supported. [1, 2, 3, 4, 5, 6, 7, 8]

All domain data, diagrams, decision scores, and scenarios are original teaching examples. No external organization is represented. Reference numbers point to primary specifications and documentation. Product behavior depends on release, configuration, and edition.

=== Reader guide | How to follow the examples
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

=== Reader guide | Running the examples
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
data_file = sys.argv[1] if len(sys.argv) > 1 else "catalog.ttl"
query_file = sys.argv[2] if len(sys.argv) > 2 else "practice.rq"
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

=== I · Foundations | The running example and its questions
> **Learning goals for this part:** Explain the two graph representations in everyday language; distinguish a model, database, query language, meaning, and validation; trace each term back to the catalog.

### Meet Maya and the learning catalog
Imagine a learning application that helps people choose their next course. Maya, a fictional learner, likes the topic Graphs and has completed the course Graph Basics. She asks: **“What should I study next, and why?”** We will follow that question throughout the book. Keep these roles distinct: Maya is a person, Graph Basics is a course, and Graphs is a topic.

Our **learning catalog** collects the people, courses, topics, and completions needed to answer Maya. The table introduces its starting facts. Short IDs such as `c1` identify courses consistently even if their titles change.

| ID | What it identifies | Starting facts |
|---|---|---|
| maya / leo | Two people | Maya likes Graphs; Leo likes Data; both completed c1 |
| graphs / data / ethics | Three topics | Subject areas used to describe courses and interests |
| c1 | Graph Basics | 60 minutes; about Graphs; no recorded prerequisite |
| c2 | Graph Search | 90 minutes; about Graphs; requires c1 |
| c3 | Query Patterns | 75 minutes; about Data; requires c1 |
| c4 | Data Ethics | 45 minutes; about Ethics; no recorded prerequisite |

### What answer are we trying to produce?
A **prerequisite** is a course that must be completed before another course. For this example, recommend a course only when it matches a topic Maya likes, she has not completed it, and she has completed all its recorded prerequisites. This is an application **policy**: an explicit decision rule.

Under that policy, the answer is **c2, Graph Search**. It is about Graphs; Maya has not completed it; and she has completed its prerequisite, c1. c1 is excluded because she already completed it. c3 and c4 do not match her recorded interests.

### Questions that guide the model
A **competency question** is a concrete question a model must answer. Here we ask which courses match Maya's interests, whether prerequisites are satisfied, and which records support the explanation. These questions guide the definitions, diagrams, and queries.

For these exercises, treat the recorded prerequisite list as complete for each course. Later we will examine why that policy differs from knowing every fact in the world.

This starting dataset is the **baseline**. Later, we will add completion-event records and evidence documents as clearly marked extensions. They are not present in the baseline files. The next section turns this familiar story into a graph, one connection at a time.

=== I · Foundations | A graph is a language for connections
### Turn the story into a picture
We have just met Maya and the learning catalog. Begin with one fact from that story: **Maya completed Graph Basics.** To draw it as a graph, place Maya in one box and Graph Basics in another, then connect them with an arrow labeled **completed**.

A **graph** consists of **nodes** (also called vertices) and **edges**, the connections between them. In this drawing, Maya and Graph Basics are nodes; the completed arrow is an edge. A **directed edge** has a start and an end. Reading Maya → completed → Graph Basics makes sense for our fact. Reversing that arrow would say that the course completed the person, which is a different and unintended statement.

### Add enough connections to answer the question
Now add Graph Search, the possible next course, and Graphs, the topic Maya likes. In the figure, boxes identify things; words beside arrows explain their connections. The arrow labeled “prerequisite of” goes from Graph Basics to Graph Search. It expresses the same requirement as “Graph Search requires Graph Basics,” read in the opposite direction.

@diagram running

Read the figure as five sentences: Maya completed Graph Basics; Maya likes Graphs; both courses are about Graphs; and Graph Basics is a prerequisite of Graph Search. Together, these facts explain why Graph Search is a candidate. The full eligibility policy will be written as queries later.

### Connect the vocabulary to this picture
An **entity** is a thing we identify: Maya is a person entity and Graph Basics is a course entity. An **attribute** describes an entity: the course's title is “Graph Basics” and its duration is 60 minutes. A **relationship** connects entities: the course is about the topic Graphs. We make Graphs an entity because many courses and learners can connect to the same topic.

A **path** is a sequence of connected steps; a **hop** is one step. Maya → Graph Basics → Graphs is a two-hop path. A **traversal** follows such connections from a starting node. A **join** combines matching information, for example by the same course ID. Engines may use either technique internally.

These are model concepts, independent of a particular database. We now need a way to represent this picture in a computer. The next section introduces the two approaches compared in this book before naming the tools around them. In this introductory figure, “label” simply means the words on an edge; later, a Neo4j node label has a more specific meaning.

=== I · Foundations | Two approaches to the same graph
### From a picture to a computer representation
We have drawn the catalog and read its connections as sentences. Now imagine implementing the application. A computer needs a precise way to organize Maya, the courses, their attributes, and their connections. That organizing convention is a **data model**: a set of building blocks and rules for representing information.

This book compares two graph data models. The first is **RDF**, which represents information as statements about identified things. The second is the **labeled property graph**, which represents nodes and relationship instances with labels and properties. Both can describe our catalog and support the recommendation question. We will explain each in ordinary language before introducing its technical vocabulary.

### Approach 1: describe things with statements
Start with “Maya completed Graph Basics.” In the RDF approach, represent it as a three-part statement: the thing being described, the relation, and the related thing. In this case those parts are Maya, completed, and Graph Basics. A three-part statement is called a **triple**.

Other triples describe the same course: Graph Basics has title “Graph Basics”; Graph Basics has duration 60 minutes; Graph Basics is a Course. The statements connect through identifiers that consistently name the same person or course. An RDF database stores such statements, and other languages can describe their meaning, query them, or check them. We will introduce those languages in the next section.

### Approach 2: describe nodes and their connections
In a labeled property graph, make a node for Maya and a node for Graph Basics, then create a COMPLETED relationship from the first to the second. Give Maya's node a Person **label**, meaning a category marker. Give the course node a Course label. Store the course's title and duration as **properties**, meaning named values attached to that node.

A particular relationship can also have properties. If we later record a completion date, it can be attached to the completion relationship or represented through an event node when more history is needed. For now, keep the unchanged baseline: Maya completed c1, with no date or score added.

### What changes, and what stays the same?
| Question | RDF representation | Labeled property graph representation |
|---|---|---|
| How is the completion expressed? | An identified person, a completed predicate, and an identified course form a triple | A COMPLETED relationship connects the person node to the course node |
| How is duration expressed? | Another statement relates the course to the value 60 | A duration property on the course node has value 60 |
| What does the user learn? | Maya completed Graph Basics | Maya completed Graph Basics |

The domain fact stays the same. The organization of that fact changes. Neither choice alone decides which recommendation policy we use, whether source data is true, or how fast an implementation runs.

### Where Neo4j fits
**Neo4j** is database software that implements a labeled property graph and provides storage, queries, and operational features. RDF is a data model rather than one particular database product. Accordingly, our detailed comparison is between an RDF-based system and a Neo4j property-graph system. “RDF versus Neo4j” is a useful shorthand only after this distinction is clear.

Next we meet the tools around the RDF approach, one responsibility at a time. Then we do the same for the Neo4j approach, before aligning them in a comparison diagram.

=== I · Foundations | Meet the RDF approach and its languages
### Why RDF comes with several names
The previous section showed how a triple records one fact. Building a useful application requires more than recording facts: we must identify things, describe categories, ask questions, and check submitted records. The RDF ecosystem names these jobs separately. This section introduces the names through the catalog needs they address; it is an orientation, not yet a syntax lesson.

### Record identified facts: RDF
**RDF** means **Resource Description Framework**. A resource is something we describe, such as Maya, c1, or a topic. RDF organizes descriptions as triples. The three parts have names: **subject** for the described thing, **predicate** for the relation, and **object** for the related thing or value. In “c1 is about Graphs,” c1 is the subject, about is the predicate, and Graphs is the object.

An identifier must distinguish the topic Graphs from an unrelated thing with the same display name. RDF uses **IRIs**, Internationalized Resource Identifiers, to name resources and predicates. An example is `https://example.org/c1`. Think of it here as a stable, globally scoped name; the identity section will explain why a name that looks like a web address is different from a text value. [1]

### Describe categories and simple hierarchies: RDFS
The catalog tells us that c1 is a Course. Suppose we also want the general definition “Every Course is a LearningResource.” A **class** names a category, and a **subclass** is a more specific category contained within another. LearningResource is the general category in this example; Course is the more specific one.

**RDFS**, RDF Schema, supplies terms for these basic category and property relationships. With the relevant reasoning enabled, the course fact and subclass definition support the conclusion that c1 is a LearningResource. This is a first example of **inference**: deriving a conclusion from supplied facts and definitions. It does not require manually adding that broader category to every course record. [11]

### Express richer logical definitions: OWL
A hierarchy is not enough for every definition. Suppose we want to define a category through relationships its members have, or declare that two categories cannot share a member. **OWL**, the **Web Ontology Language**, offers a formal language for such commitments. An **ontology** is the explicit domain model containing those concepts, relations, and, when formalized, logical statements called **axioms**.

OWL is not itself a database or an algorithm. A **reasoner** is software that computes the conclusions permitted by the selected semantics. We will study the difference between definitions and algorithms later; for this first map, associate OWL with the question “What do our definitions logically imply?” [3]

### Ask questions about the facts: SPARQL
Our application needs to ask “Which courses are about Graphs?” and eventually “Which course is eligible for Maya?” A **query language** provides precise notation for such questions. **SPARQL**, whose recursive expanded name is SPARQL Protocol and RDF Query Language, is the query language used in the RDF chapters. It matches patterns in RDF data and returns answers. Merely writing a SPARQL query does not turn on every possible OWL inference. [4]

### Check submitted records: SHACL
A course import might omit duration. We need to ask whether that submitted record satisfies our acceptance rules. **SHACL**, the **Shapes Constraint Language**, expresses checks such as “a Course must have one positive integer duration.” A **shape** is a collection of conditions applied to selected data. Validation compares the supplied graph with those conditions and reports violations. [5]

Notice the difference in purpose: a definition can say that a Course is a LearningResource; a check can say that an incoming Course record lacks its required duration. We need both ideas, but they answer different questions.

### Keep only the names attached to the jobs
RDF records statements; RDFS and OWL describe meaning; SPARQL asks questions; SHACL checks supplied data. These are separable capabilities. A system may use RDF and SPARQL without using OWL, and a SHACL check is not automatically installed as a database write constraint.

You do not need to memorize syntax yet. The detailed chapters return to each job with executable or carefully scoped examples. Next we introduce the property-graph vocabulary with the same discipline, so the later comparison has two understandable sides.

=== I · Foundations | Where the RDF database fits
### The question left by the language map
We have named RDF, RDFS, OWL, SPARQL, and SHACL. Which of those stores the graph? None is the name of a particular database product. RDF specifies the data model; the other names identify languages or standards used around that model. A software system must still store data and execute requests.

### The database category: RDF store or triplestore
An **RDF store**, often called a **triplestore**, stores and queries RDF statements. These are categories of database software, just as “relational database” is a category. They do not identify one specific product.

A **persistent store** retains data beyond the lifetime of the process that loaded it, usually using disk storage and recovery mechanisms. An **in-memory graph** keeps its working data in process memory. A library may offer different storage backends; which one we instantiate determines the behavior. Neither the RDF model nor the SPARQL language alone promises persistence.

### A concrete implementation: Jena TDB2 with Fuseki
To attach real names to the roles, consider **Apache Jena**, a software framework for RDF. Its **TDB2** component provides RDF storage and query on a single machine. **Fuseki** is a SPARQL server that can expose a dataset to client applications and work with a persistent storage layer. Thus TDB2 is a storage-engine name and Fuseki is a server name within this example stack. [33, 34]

A **SPARQL endpoint** is an address to which a client sends a query and from which it receives results. The endpoint is the service interface; it is not another name for RDF itself. **Client** here means the program asking the question, such as our learning application.

### Read the implementation diagram by role
In the figure below, the application sends a question to the server. The server evaluates the question using the stored RDF dataset and returns results. The arrows follow the query path; results return along the reverse route. This drawing describes one example implementation. OWL reasoning and SHACL validation are separate capabilities to configure; their presence is not implied simply by drawing a database box.

@diagram rdfstore

This is an illustrative implementation, not the database used by the baseline lab and not a recommendation that it is best for every project. For an optional alternative framework, see the RDF4J repository documentation in reference [35]; no additional product names are needed to follow this example.

### What the companion lab actually runs
Our executable RDF exercise uses **RDFLib**, a Python library, with an in-memory Graph object. It reads catalog.ttl, runs SPARQL queries locally, and uses separate validation and inference libraries for the stated checks. It does not start Fuseki, TDB2, RDF4J Server, or another database server. Passing it verifies the small fixture's behavior in that environment, not a deployed store's scalability or transaction guarantees.

The comparison is therefore RDF data model + a chosen RDF implementation + SPARQL, alongside LPG data model + Neo4j + Cypher. The next section introduces the latter stack. Keeping model, library, storage engine, server, and query language distinct will make the rest of the book easier to follow.

=== I · Foundations | Meet labeled property graphs and Neo4j
### Rebuild the same fact using nodes
The RDF orientation separated statements, meaning, questions, and checks. We now return to “Maya completed Graph Basics” and introduce the second approach's building blocks. This is still the same catalog; only its representation is changing.

A **labeled property graph**, abbreviated **LPG**, contains nodes, directed relationship instances, and properties. “Labeled” refers to category markers on nodes. “Property” refers to named stored values. In our example, Maya's node has the label Person; the Graph Basics node has the label Course.

### Labels, relationship types, and properties do different jobs
A **node label** answers “Which category does this node belong to?” Course and Person are examples. A **relationship type** answers “What kind of connection is this?” COMPLETED connects Maya to a course, while ABOUT connects a course to a topic. Capitalization here is a naming convention used by the examples.

A **property** answers “Which value is stored on this node or relationship?” The course node can have an id property with value c1, a title property with value Graph Basics, and a durationMinutes property with value 60. A property key is the name of the field; its value is the stored content. The topic Graphs remains a separate node because many people and courses can connect to that same topic.

A node may have more than one label. A relationship is a particular connection between two nodes, so repeated occurrences can be represented separately. Whether a completion should be one relationship or an independently identified event is a domain-modeling decision that we will revisit later.

### The database is Neo4j; the query language is Cypher
**Neo4j** is the database system used to store and operate this graph in our second route. **Cypher** is the query language used to ask it questions. A **declarative** query describes the matches or results wanted, while the database chooses how to execute the request.

For example, the question “Find Course nodes connected by ABOUT to the Graphs topic” describes a pattern to match. Cypher supplies notation for that pattern. The later code chapter teaches its parentheses, arrows, variable names, and clauses; none of those symbols is needed to understand the model here. [6, 20]

### Where meaning and quality come from
A label named Course is useful, but its name alone does not define what counts as a course or whether course categories inherit from one another. The team must record those meanings in its domain model and choose how any additional rules run. Ontologies can guide a property-graph design too; storing an ontology does not automatically execute OWL reasoning.

For quality, a database **constraint** can enforce a supported storage rule, such as preventing two Course nodes from using the same id value. An application or import pipeline can perform additional checks, such as requiring a valid duration or rejecting a prerequisite cycle. The available native constraints depend on the chosen database version and edition. [7]

### We now have two sets of names for comparable jobs
In the first route, RDF represents facts and SPARQL queries them. In the second, an LPG represents facts and Cypher queries them in Neo4j. Both also need identity, meaning, and quality policies. The next section aligns those responsibilities visually; it introduces no new programming syntax.

=== I · Foundations | Separate the five layers
We have now introduced both approaches and the main names associated with each. We can finally compare them without treating every name as the same kind of thing. Return to Maya's recommendation: a working system must identify her courses, represent connections, interpret them, answer a question, and check the records it accepts.

### What “five layers” means here
A **layer** in this comparison is one responsibility of the system. The five responsibilities are identity, representation, meaning, querying, and quality. They are a teaching framework, not five servers and not a required sequence of processing steps. A single database may address several of them; several tools may cooperate on one of them.

### 1 · Identity: which thing are we referring to?
Every mention of c1 must refer to the same intended course. RDF uses IRIs as resource identifiers. A Neo4j application usually chooses stable node keys and can also retain IRIs. In either case, we must decide when two source records identify the same course. Neither naming convention makes that decision for us.

### 2 · Representation: how are the facts organized?
RDF represents “Maya completed c1” as a subject–predicate–object triple. The LPG represents it as a relationship between nodes, with category labels and properties describing the nodes. This is the data-model comparison. It is separate from the choice of database software that stores and executes the model.

### 3 · Meaning: what do the terms commit us to?
Suppose we say that every Course is a LearningResource. In an RDF-based system, RDFS or OWL can express that meaning with standardized logical consequences. In an LPG application, definitions and any executable rules must also be specified; a Course label alone does not install inheritance or OWL reasoning. Both approaches can use an ontology, but the runtime behavior must be explicit.

### 4 · Querying: how do we ask for the answer?
“Which course can Maya study next?” is our query problem. The RDF route uses SPARQL; our Neo4j route uses Cypher. Both can express the catalog policy. Query syntax and a graph data model are different layers: knowing how a fact is represented is not yet the same as knowing how to ask for it.

### 5 · Quality: which submitted records are acceptable?
A course record without duration may violate our data contract. SHACL can check an RDF graph against that condition. Neo4j constraints and application or pipeline checks can enforce the supported rules in the LPG route. We must also specify when a check runs and whether a failure blocks publication, rejects a write, or produces a report.

### How to read the comparison diagram
The diagram below is a **map of responsibilities**, not a data-flow chart. The left column names one of the five jobs. The middle column shows the RDF-side mechanism already introduced; the right column shows the LPG/Neo4j-side mechanism. Read across one row to compare the same job, then move to the next row. There are no arrows because the drawing does not prescribe an execution order.

@diagram stack

For example, read the querying row as “use SPARQL in the RDF route, or Cypher in this LPG route.” Read the quality row as a separate question about checking data. OWL appears in the meaning row because interpreting definitions is different from rejecting an incomplete submitted record.

### The comparison this prepares us to make
RDF and LPG are data models; SPARQL and Cypher are query languages; OWL and SHACL address different semantic and validation needs; Neo4j is database software. When someone says “RDF versus Neo4j,” clarify that the architectural choice is between complete candidate systems with these responsibilities assigned.

The later comparison chapters assess those systems against workload, governance, and operational requirements. At this stage we are only building the map needed to read them. Next we clarify the word schema, which is used for more than one of these responsibilities, and then establish the catalog's identity policy. [1, 3, 5, 6, 8]

=== I · Foundations | What schema means in each approach
### One word, three different questions
The five-layer map separates meaning, quality, and execution. The word **schema** can refer to artifacts in any of these areas, which can make discussions confusing. Before continuing, distinguish the question being asked whenever someone says “Does this graph have a schema?”

### A conceptual schema explains the domain
A **conceptual schema** describes the kinds of things in the domain and what their relationships mean. In our catalog, Person, Course, Topic, completed, and requires belong to that model. An ontology can make some of those definitions formal. A property-graph application also has a conceptual schema, even if its database did not require one to be declared before loading nodes.

### A validation schema describes acceptable submissions
A **validation schema** states what a submitted record must contain or satisfy. “Every Course record must have one positive integer duration” is such a rule. A SHACL shape is one way to express it for RDF. Supported database constraints and additional application checks can cover acceptance rules in the LPG route.

This schema answers whether the supplied record meets the contract; it does not, by itself, prove that the recorded duration is correct in the world. A course can have a well-formed but inaccurate value.

### A physical schema supports execution
A **physical schema** concerns how a database supports storage and access, such as indexes. An **index** is a lookup structure that can help find a node or statement by a selected value. For example, looking up course id c1 efficiently is an execution concern. Creating that index does not define what Course means or prove that c1 has a valid duration.

### Separate a standard from its implementation
A **standard** specifies agreed syntax or behavior. An **implementation** is software that realizes some part of it. RDF and its supporting standards can be implemented by different databases; those databases need not have identical indexes, transaction behavior, or reasoning support. Similarly, the abstract LPG model is distinct from the particular features of a Neo4j release.

We will keep these senses separate in the detailed chapters. First, however, both approaches need the same foundation: a reliable way to identify the course and learner mentioned by each fact.

=== I · Foundations | Identity before intelligence
The catalog table gave Graph Basics the ID c1. Before encoding that fact in either graph model, we need to explain why the ID matters: every completion and prerequisite must refer to the correct course, even after a rename or an import from another source.

### A name is not an identifier
Two courses can share a title. One course can change its title. Treating the title as identity creates accidental merges and broken links. Use a stable **key**, a value selected to distinguish records within a defined scope. A **canonical identifier** is the preferred identifier after reconciliation across sources.

In the figure, two independent source catalogs use local IDs c1 and 73 for the same course. Mapping both records to a canonical identifier is a reviewed identity decision; matching the strings alone would not establish it.

@diagram identity

An **IRI**, or Internationalized Resource Identifier, is a globally scoped identifier syntax. In RDF, `https://example.org/c1` identifies a resource; the text literal `"https://example.org/c1"` is a string value. These are different RDF terms. An IRI need not resolve to a web page to be a valid graph identifier, although publishing useful descriptions is often helpful. [1]

### An identity policy for the catalog
Use `https://example.org/c1` for the abstract course and separate IDs for editions when prerequisites or assessment rules differ. Store source keys in a mapping table with a source namespace. Retain the evidence and date of every merge decision. Do not generate a new ID because a title was corrected.

In Neo4j, store a unique application key such as `id: 'c1'`; an additional `iri` property can preserve cross-system identity. Database-internal identifiers are implementation details and should not be your durable integration contract. Global identifiers are possible in a property graph; RDF simply makes them fundamental to the data model.

### Entity resolution is a decision process
**Entity resolution** determines whether records describe the same real-world thing. **Deduplication** removes redundant representations after that decision. Similar titles or close embeddings (numeric vectors used for similarity comparison, introduced in Chapter 8) are useful evidence, not proof. Distinguish exact identity from related editions, translations, or approximate matches. A false merge can propagate incorrect prerequisites and recommendations throughout the graph.

> Keep source identity, canonical identity, and display names separate. Correct identity is often more valuable than a sophisticated graph algorithm.

### Connection to the next part
We now know the story, the graph vocabulary, and the identity policy. The next part uses RDF to write the catalog as statements without changing what the learner and course IDs refer to.

### Check your understanding
**Try first:** core questions for this chapter are 1, 3, 4, 6, 7, 9, 10, 13, 16. They cover its main concepts and application decision. Attempt the remaining questions as a second pass. Cover the next answer with a sheet or scroll it out of view while writing your prediction. Compare the explanation only after committing an answer.

These questions revisit the whole Foundations part, from Maya's catalog to the five responsibilities and identity policy. Try answering each question before reading its answer. Explain your answer using the catalog rather than relying only on a memorized definition. No query syntax is required yet.

### Review 1 · Read the graph and the recommendation
**Question 1: In “Maya completed Graph Basics,” what are the nodes, the connection, and its direction?**

**Answer:** Maya and Graph Basics are the nodes. The completed connection goes from Maya to Graph Basics. Read the start, connection name, and end together as a sentence. Reversing the same named connection would say that Graph Basics completed Maya, which changes the meaning. To express the original fact in the opposite direction, the connection would need a different name, such as “was completed by.”

**Question 2: Why do we represent Graphs as a topic entity but keep 60 minutes as a course attribute?**

**Answer:** Graphs is something that several courses and learners connect to: a course is about Graphs, and Maya likes Graphs. Giving the topic its own identity lets those connections meet at the same thing. In the starting model, 60 minutes simply describes a course's duration. This is a modeling choice guided by the questions we need to answer; it is not a rule that every word must become a node or every number must remain an attribute.

**Question 3: How many hops are in the path Maya → Graph Basics → Graphs, and what does that path establish?**

**Answer:** There are two hops: one from Maya to the course she completed, then one from that course to its topic. The path establishes that Maya completed a course about Graphs. It does not, by itself, establish that she likes Graphs; the catalog records her interest through a separate likes connection. A connected path must be interpreted through the meaning of each connection.

**Question 4: Why is Graph Search, c2, the baseline recommendation for Maya?**

**Answer:** Our policy requires a matching interest, an uncompleted course, and completion of every recorded prerequisite. c2 is about Graphs, which Maya likes; she has not completed c2; and she has completed c1, its prerequisite. c1 fails the uncompleted condition. c3 and c4 fail the matching-interest condition. The result follows from both the recorded facts and our stated policy, not from the graph shape alone.

**Question 5: What is a competency question, and how does it help us choose what to store?**

**Answer:** A competency question states something the model must be able to answer, such as “Has Maya completed every prerequisite of this candidate course?” That question tells us we need learner completions and course prerequisites, with identifiers that let us connect them. It also reveals a completeness assumption: in this exercise, we treat each recorded prerequisite list as complete. If required facts are missing, changing the database product alone cannot repair the answer.

### Review 2 · Put each technology in its place
**Question 6: Is RDF the name of the database server? Where is the database in the RDF approach?**

**Answer:** No. RDF is the data model for representing statements. An implementation stores and queries those statements. For example, an RDF stack can use TDB2 for persistent storage and Fuseki to expose a SPARQL service. Our small lab instead uses RDFLib, a Python library, with a graph held in memory; it starts no separate database server. Distinguish the model, the selected storage implementation, and any server that provides access to it.

**Question 7: Why does “RDF versus Neo4j” need clarification?**

**Answer:** RDF is a data model, whereas Neo4j is a database system implementing a labeled property graph. To compare representations, compare RDF with the LPG model. To compare working systems, compare a chosen RDF implementation and its configuration with a chosen Neo4j implementation and its configuration. Otherwise, a model's possibilities can be confused with a particular product's implemented features.

**Question 8: What do SPARQL and Cypher do, and do they decide the recommendation policy for us?**

**Answer:** They are query languages: SPARQL is used in our RDF route, and Cypher in our Neo4j route. We use them to express questions and retrieve matching results. The application designer still chooses the policy, such as requiring all recorded prerequisites. A query can express the wrong policy precisely, so we must check that its meaning matches the intended question.

**Question 9: Which tools address meaning, and which address acceptance checks?**

**Answer:** RDFS and OWL can express formal meaning, such as every Course being a LearningResource. A configured reasoner can derive the consequences supported by those definitions. SHACL can check whether submitted RDF data meets a condition, such as requiring a positive integer duration. In our LPG route, supported Neo4j constraints and application or pipeline checks cover acceptance rules. These jobs cooperate, but deriving a category and checking a record are different tasks.

**Question 10: Is an ontology an algorithm, and can a property-graph application use one?**

**Answer:** An ontology describes the domain's concepts, relationships, and definitions; a formal ontology can include logical axioms. It is not an algorithm. An algorithm is a procedure for carrying out a computation. A property-graph application can use an ontology to guide its labels, relationships, and documented meanings. However, a Course label or a stored ontology does not automatically make Neo4j execute OWL reasoning; the chosen runtime must provide any required reasoning behavior explicitly.

### Review 3 · Separate responsibilities and protect identity
**Question 11: What are the five responsibilities, and are they five mandatory servers?**

**Answer:** They are identity, representation, meaning, querying, and quality. For c1, they ask: which course is this; how are its facts organized; what does Course mean; how do we retrieve answers; and which records are acceptable? They are a way to separate design questions, not a required deployment arrangement or processing order. One component can serve several responsibilities, and several components can cooperate on one responsibility.

**Question 12: What is the difference between a conceptual model, a validation schema, and a physical schema?**

**Answer:** A conceptual model defines the domain, such as learners, courses, topics, and completions. A validation schema describes acceptance conditions, such as requiring a positive integer duration. A physical schema supports storage and access, for example through an index on a course identifier. An index may speed up a lookup, but it does not define Course or establish that a duration is valid. Always ask which sense of “schema” is intended.

**Question 13: If Graph Basics is renamed, should c1 receive a new identifier? What if another course has the same title?**

**Answer:** A title correction or rename does not, by itself, change the course's identity, so the stable identifier stays the same. A different course may share that title and still need a different identifier. This is why completion and prerequisite links should refer to stable course identifiers rather than display titles. A materially different course edition may need its own identity under the catalog's stated policy.

**Question 14: Is the IRI https://example.org/c1 the same RDF term as the string “https://example.org/c1”? Must the IRI open a web page?**

**Answer:** No. Used as an IRI, it identifies a resource; used as a string literal, the same characters are a text value. Their roles in RDF differ even though the displayed characters match. An IRI does not have to resolve to a web page to be a valid identifier. Providing a useful description at that address can help users, but identification and web retrieval are separate concerns.

**Question 15: Two source catalogs use c1 and 73 for courses with the same title. Can we merge them immediately?**

**Answer:** No. Matching titles are evidence to investigate, not proof of identity. Entity resolution determines whether the records refer to the same intended course, using appropriate evidence such as edition, provider, or content. After that decision, deduplication can remove redundant representations, and a canonical identifier can connect the source records. Preserve the source identifiers and the evidence behind the decision so the mapping can be reviewed.

**Question 16: A course passes every configured validation check. Does that prove its facts are true or that the system will scale?**

**Answer:** No. A positive integer duration can satisfy a shape while still being inaccurate in the real world. Likewise, a passing in-memory exercise establishes behavior only for the tested data, software, and checks. It does not establish production throughput, durable storage, or deployment guarantees. Ask what each check actually measured before drawing a broader conclusion.

### Apply the foundations to one new requirement
**Question 17: Preview — revisit after Section 5.1. The application must now keep the date of each completion and allow the same learner to complete a course more than once. What should you decide before writing a query?**

**Answer:** First clarify what counts as a distinct completion and how its date and identity are recorded. A bare “Maya completed c1” connection does not explain how to distinguish repeated occurrences. An LPG can use separate relationship instances with properties, or an event node when the completion needs its own identity and further connections. An RDF model can introduce an identified completion event with links to the learner, course, and date. These are possible extensions, not facts already present in our baseline. We will develop event modeling later; the lesson here is to settle the meaning and identity of the new information before choosing query syntax.

**Ready to continue:** You should now be able to explain the catalog to another reader, place each technology in the correct role, and distinguish a stored fact from a definition, a policy, and a validation rule. If a question was difficult, revisit the corresponding Foundations section before beginning the RDF syntax chapter.

=== II · RDF and semantic graphs | RDF statements, terms, and datasets
> **Learning goals for this part:** Read a triple and a Turtle fragment; separate RDFS/OWL consequences from SHACL acceptance checks; explain what a missing fact does and does not imply.

We will now encode the catalog using the first approach, RDF. Keep the simple fact “c1 is about Graphs” in mind: the goal is to turn that connection into a precisely identified statement. This section introduces the pieces needed to read the first RDF fragment.

### The triple
RDF means **Resource Description Framework**. In RDF 1.1, a triple has a **subject**, a **predicate**, and an **object**. The subject identifies what is described; the predicate identifies the relationship or attribute; the object is the related resource or value. An RDF graph is a set of triples, so adding an identical triple twice does not create two statement occurrences. [1]

**Worked fragment — describe one course.** This is an isolated syntax example, not the complete catalog. We use the prefix `ex:` as a short form of `https://example.org/`; consequently, `ex:c1` names c1, Graph Basics, and `ex:graphs` names the Graphs topic. The title is language-tagged here to introduce that notation; the later baseline uses plain string titles.

Before reading this first Turtle block, use this symbol key. Section 2.2 will practice its abbreviations.
- @prefix declares an abbreviation; angle brackets enclose a full IRI. Thus ex:c1 expands to https://example.org/c1.
- xsd abbreviates XML Schema's datatype namespace, used here for integer values.
- Quotation marks surround literal text. The ^^ marker attaches a datatype; @en supplies an English language tag.
- A semicolon means same subject, next predicate; a final period ends the group of statements.

```turtle
@prefix ex: <https://example.org/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

ex:c1 ex:title "Graph Basics"@en ;
      ex:durationMinutes "60"^^xsd:integer ;
      ex:about ex:graphs .
```

Read the fragment as three statements about c1: its title is “Graph Basics” in English, its duration is 60 minutes, and it is about Graphs. Here `ex:c1` is the subject of three triples. `ex:title` and `ex:about` are predicates. The title and duration are **literals**, value terms that each have a datatype. A language-tagged string also has a language tag and datatype `rdf:langString`. `ex:graphs` is an IRI naming a topic. `xsd:integer` names an integer datatype. `"60"` is a string; `"60"^^xsd:integer` is an integer-typed literal.

### Three kinds of RDF term
An **IRI** names a resource. A **blank node** represents a resource without assigning a global IRI; its local identifier is not a portable business key. A **literal** represents a value. Under RDF 1.1, subjects are IRIs or blank nodes, predicates are IRIs, and objects may be any of the three term kinds. [1]

### Graphs versus datasets
An **RDF dataset** contains a default graph and zero or more **named graphs**. A named graph associates a graph name with a graph. A stored statement with its graph name is often called a **quad**. Naming a graph does not itself prove its author, truth, or access permissions; you must define those conventions.

> The triple is the logical unit. A triplestore is a database designed to store and query RDF; a quadstore also exposes graph organization. Neither term specifies the complete operational behavior of a product.

=== II · RDF and semantic graphs | Turtle, JSON-LD, and reading syntax
The previous section explained what an RDF statement means. Now we look at how to write the same kinds of statements in text. We will compare a readable Turtle fragment with a JSON-LD fragment, while keeping separate the text format and the graph it represents.

### Serialization is not a different graph model
A **serialization** is a textual representation of a data model. We first use **Turtle**, a readable text notation for RDF statements. The following example teaches its abbreviations. Later in this section we use JSON-LD to show another text representation. Changing serialization does not necessarily change the graph; changing the statements does. [9, 10]

**Isolated Turtle variation.** To demonstrate comma notation, this fragment gives c1 two topics, Graphs and Data. The baseline later gives c1 only Graphs. Do not carry this extra Data connection into the baseline queries.

```turtle
@prefix ex: <https://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .

ex:c1 a ex:Course ;
      ex:title "Graph Basics" ;
      ex:about ex:graphs, ex:data .
```

Read `a` as `rdf:type`: c1 is an instance of Course. A semicolon repeats the subject with a new predicate. A comma repeats the subject and predicate with another object. The final period ends the group. Prefix declarations abbreviate IRIs; they do not change identity. Replacing the prefix name while preserving its expanded IRI preserves the term. [9]

**JSON-LD** means **JavaScript Object Notation for Linked Data**. JSON is a text format that groups named fields and values inside braces; you do not need to know JavaScript to read this example. JSON-LD adds a context that maps those field names to RDF identifiers.

**Separate JSON-LD fragment.** This block describes c1 with just the Graphs topic. It is not an exact rewrite of the preceding two-topic variation; its purpose is to show how a JSON context distinguishes a resource link from a text value.

```json
{
  "@context": {
    "ex": "https://example.org/",
    "title": "ex:title",
    "about": {"@id": "ex:about", "@type": "@id"}
  },
  "@id": "ex:c1",
  "@type": "ex:Course",
  "title": "Graph Basics",
  "about": "ex:graphs"
}
```

The @id setting for about tells JSON-LD to read its value as a resource identifier rather than an ordinary string. This directed interpretation is sometimes called coercion. A **context** controls this interpretation. Inspect contexts during integration: text that looks similar can expand into different predicates. Do not fetch arbitrary remote contexts in an untrusted ingestion path without an explicit network policy. [10]

### Beginner check
Does a different ordering of Turtle statements imply a different graph? No: RDF graph statements are unordered. If order matters, such as an ordered learning path, model an explicit sequence or RDF list rather than relying on file order.

### Other formats you may encounter
The two examples above are enough for the tutorial. For orientation, **N-Triples** writes RDF in a simple one-triple-per-line form, while **TriG** adds named-graph notation to Turtle-style text. We will not use either format in the baseline lab; they are alternatives for exchange, not additional concepts you must apply to the examples. [9]

=== II · RDF and semantic graphs | A complete RDF catalog
The earlier RDF fragments taught individual symbols. We now assemble the complete starting catalog so that the coming queries have one stable dataset. From this point, “the baseline” refers to the facts in this block and in catalog.ttl, unless an example explicitly announces a change.

### Explicit facts first
This core dataset deliberately uses direct completion links. It is the baseline for the SPARQL exercises. The companion `catalog.ttl` contains the same facts. All prefixed terms below expand under `https://example.org/` except the standard RDF namespace used by `a`.

**Baseline data — save as catalog.ttl.** This is the complete data graph used by the SPARQL lab. It contains learner and course facts, not the later ontology, shapes, completion-event records, or evidence documents.

```turtle
@prefix ex: <https://example.org/> .

ex:maya a ex:Person ; ex:name "Maya" ;
  ex:likesTopic ex:graphs ; ex:completed ex:c1 .
ex:leo a ex:Person ; ex:name "Leo" ;
  ex:likesTopic ex:data ; ex:completed ex:c1 .

ex:graphs a ex:Topic ; ex:name "Graphs" .
ex:data a ex:Topic ; ex:name "Data" .
ex:ethics a ex:Topic ; ex:name "Ethics" .

ex:c1 a ex:Course ; ex:id "c1" ;
  ex:title "Graph Basics" ; ex:durationMinutes 60 ;
  ex:about ex:graphs .
ex:c2 a ex:Course ; ex:id "c2" ;
  ex:title "Graph Search" ; ex:durationMinutes 90 ;
  ex:about ex:graphs ; ex:requires ex:c1 .
ex:c3 a ex:Course ; ex:id "c3" ;
  ex:title "Query Patterns" ; ex:durationMinutes 75 ;
  ex:about ex:data ; ex:requires ex:c1 .
ex:c4 a ex:Course ; ex:id "c4" ;
  ex:title "Data Ethics" ; ex:durationMinutes 45 ;
  ex:about ex:ethics .
```

The bare numbers are Turtle integer literals. The absence of `ex:requires` for c1 and c4 means no such prerequisite triples are present in this dataset. It does not establish universal absence. The application may nevertheless define this catalog snapshot as complete for eligibility decisions.

### Inspect it before adding intelligence
Count four Course instances and two Person instances. Check that c2 requires c1. Check that both learners completed c1, but only Maya likes Graphs. A query finding everyone who completed a course will therefore return both Maya and Leo.

For now, inspect the statements without running a query. Chapter 3 introduces matching and then shows how adding a second topic can create repeated result rows; wait until that example to change the data.

=== II · RDF and semantic graphs | RDFS: vocabulary and simple inference
The catalog says that c1 is a Course. We now add a different kind of knowledge: every Course is also a LearningResource. This lets us show how a general definition can imply a fact that was not written explicitly about c1.

### Classes and properties
A **class** describes a category of resources; an **instance** is a member of a class. A **property** expresses a relationship or value association. **RDFS**, RDF Schema, supplies vocabulary such as subclass, subproperty, domain, and range. It supports basic entailments, conclusions that follow from the stated facts and chosen semantics. [11]

**Schema extension — classify the course.** This fragment adds category definitions and repeats one c1 fact so it can be understood on its own. `rdfs:` abbreviates the standard RDF Schema vocabulary. The general term LearningResource includes both courses and articles.

```turtle
@prefix ex: <https://example.org/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

ex:Course rdfs:subClassOf ex:LearningResource .
ex:Article rdfs:subClassOf ex:LearningResource .
ex:about rdfs:domain ex:LearningResource ;
         rdfs:range ex:Topic .
ex:c1 a ex:Course ; ex:about ex:graphs .
```

The figure shows the category relationships just introduced. Course and Article point toward their more general category, LearningResource. It is a class hierarchy, not the course-prerequisite graph: no arrow here says which course Maya must study first.

@diagram ontology

With RDFS entailment, c1 is a LearningResource because Course is a subclass of LearningResource. Also, the use of `ex:about` supports classifying its subject as a LearningResource and its object as a Topic. **Domain** describes the subject class implied by use of a property; **range** describes the object class. They are inference statements, not input rejection rules. [11]

### The domain trap
Suppose someone writes `ex:maya ex:about ex:graphs`. An RDFS reasoner can infer that Maya is a LearningResource. It does not reject the triple merely because Maya was also typed Person. Whether those classifications conflict requires additional semantics; whether the input is acceptable requires a validation policy.

**Subproperty** means that every pair related by a more specific property is also related by the more general property. If `teachesTopic` is a subproperty of `about`, each teachesTopic statement entails an about statement. An endpoint that performs only explicit triple matching will not automatically return inferred statements. Verify the configured entailment regime. [11, 12]

=== II · RDF and semantic graphs | Ontology is a model, not an algorithm
RDFS has introduced categories and their relationships. Before adding stronger logical expressions, pause to name the artifact we are designing: an ontology. We will connect that term to the course definitions already in use and explain how it differs from the software that reasons over them.

### What an ontology contains
An **ontology** is an explicit model of concepts, relations, and commitments about their meaning. A lightweight ontology may define only a vocabulary and hierarchy. A formal ontology adds logical **axioms**, statements that constrain which possible situations, called interpretations, count as valid. **Ontology engineering** is the process of building and maintaining that model. A **reasoner** is software that computes consequences or detects inconsistency. The ontology itself is neither the process nor the algorithm.

### From questions to commitments
Start with competency questions, identify entities, write definitions, decide identity boundaries, and only then choose formal axioms. In our catalog, a Course is a learning offering, a Topic is a subject area, and a Completion is a recorded event connecting one learner to one course. A new edition may be a separate offering, depending on the business meaning of “completed.”

A **taxonomy** is a classification hierarchy. A **thesaurus** adds controlled terms and semantic associations. A **controlled vocabulary** restricts the terms used for a field. SKOS, the Simple Knowledge Organization System, provides concepts, preferred labels, and broader/narrower associations for knowledge organization. A SKOS broader relation should not casually be treated as the OWL subclass relation (also called class subsumption). [13]

### Ontology in a property graph
You can represent Course and LearningResource as nodes linked by `SUBCLASS_OF`, or encode the domain vocabulary in labels, metadata, documentation, and validation code. You can also retain ontology IRIs as node properties and apply external reasoning. These are legitimate ontology-driven designs.

However, storing `(:Class)-[:SUBCLASS_OF]->(:Class)` does not make Neo4j automatically implement OWL semantics. The application must decide how instance labels inherit, how rules run, and how derived facts are retracted. A graph containing ontology-shaped data is different from an engine executing that ontology's formal semantics.

> Choose the smallest semantic commitment that answers the questions. An informal concept model can be useful; formal axioms become valuable when their consequences are required and governed.

=== II · RDF and semantic graphs | OWL: express meaning precisely
A class hierarchy can say that every Course is a LearningResource, but it cannot express every definition we might need. We now use OWL to define a category of people by a relationship they have. This is a separate schema example; it does not change the recommendation policy.

### Relations, restrictions, and definitions
**OWL**, the Web Ontology Language, can express richer class descriptions than RDFS. An **object property** connects individuals; a **datatype property** connects an individual to a data value. A **restriction** describes individuals by their property relationships. The following Turtle encodes an OWL class definition. [3, 14]

**Isolated ontology definition — Graduate.** We introduce Graduate only to illustrate a logical definition: in this example it means a Person who completed at least one Course. It is not a real graduation rule and is not used to decide recommendations. Square brackets introduce unnamed structures; parentheses write an RDF list, the form OWL uses for the component class descriptions supplied to owl:intersectionOf.

```turtle
@prefix ex: <https://example.org/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

ex:completed a owl:ObjectProperty .
ex:Course a owl:Class .
ex:Person a owl:Class .
ex:Graduate a owl:Class ;
  owl:equivalentClass [
    a owl:Class ;
    owl:intersectionOf (
      ex:Person
      [ a owl:Restriction ;
        owl:onProperty ex:completed ;
        owl:someValuesFrom ex:Course ]
    )
  ] .
```

This defines Graduate as a Person who completed at least one Course. The label is intentionally simplified for teaching; a real graduation policy would need more conditions. An **existential restriction**, `someValuesFrom`, requires at least one related value in the specified class. An **intersection** requires membership in all component classes. **Equivalent classes** have the same members; a subclass statement expresses only one direction. [14]

### Read the Graduate definition from the outside inward
1. equivalentClass says Graduate has exactly the members described inside the brackets: both directions of the definition hold.
2. The outer square brackets describe an unnamed class using a blank node. intersectionOf supplies an RDF list of the conditions to combine.
3. The first list member, Person, requires membership in that class.
4. The second member is an unnamed Restriction. onProperty names completed; someValuesFrom Course requires at least one completed value that is a Course.

Together, a Graduate in this teaching example is a Person who completed at least one Course, and every such Person is a Graduate. The inner brackets describe a restriction, not a second learner or a hidden event. This definition does not require every completed value to be a Course, and it does not implement a real graduation policy.

### Necessary versus sufficient
“Every Graduate completed a Course” gives a necessary condition. It does not mean every person who completed a course is a Graduate. The equivalent-class definition above supplies both directions, so Maya can be classified as Graduate when the appropriate facts and reasoning support it.

**Universal restriction**, `allValuesFrom`, says that all values reached by a property belong to a class; by itself, it does not require any values to exist. A reasoner checks logical consequences, not whether a form has all mandatory fields. [14]

=== II · RDF and semantic graphs | Open world, identity, and consistency
The OWL definition raises a practical question: what can we conclude when a completion is missing from the file? This section explains the logical assumptions behind that answer, then contrasts them with the catalog policy that decides what Maya may study next.

### Missing is not false
The **open-world assumption** permits facts that are not recorded to be true. If no completion for Maya and c2 is recorded, OWL does not conclude that Maya did not complete c2. A **closed-world policy** treats a defined dataset as complete for a defined decision. Applications often need that policy for recommendation filtering, while retaining open-world semantics for integration. [15]

The figure follows one missing completion record through two interpretations. OWL leaves the real-world completion unknown. An application policy may treat the missing record as insufficient evidence for eligibility, provided it declares that decision rule.

@diagram world

### Different names need not mean different things
OWL does not generally assume that different IRIs identify different individuals. This is the absence of a universal **unique-name assumption**. Explicit inequality can distinguish individuals. Conversely, `owl:sameAs` asserts identity: it is much stronger than “similar,” “same title,” or “probably a duplicate.” [15]

For a separate catalog extension, imagine that a learner can have one primary mentor. Declare the new relation primaryMentor a **functional property**, meaning at most one object value per individual under OWL semantics. Suppose two imports give Maya mentor IDs mentor-a and mentor-b. OWL can imply that these IDs name the same mentor, rather than simply reject the second record as a duplicate-value error. If the objects are also declared different, the ontology can become inconsistent. Datatype values introduce their own compatibility rules.

**Isolated mentor variation — two names, one possible mentor.** These triples describe the same hypothetical extension; they are not baseline facts. owl:FunctionalProperty limits each subject to at most one distinct object for this relation.

```turtle
@prefix ex: <https://example.org/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
ex:primaryMentor a owl:ObjectProperty, owl:FunctionalProperty .
ex:maya ex:primaryMentor ex:mentorA, ex:mentorB .
```

Under the relevant OWL semantics, the two mentor names must denote the same individual: ex:mentorA owl:sameAs ex:mentorB follows. Two labels on imported records need not mean two distinct people. If another axiom explicitly says they are different individuals, that additional assertion conflicts with the functional-property facts.

### Consistency is not completeness
An ontology is **consistent** when all its axioms can be true together. In logic terms, there is at least one possible situation, called an **interpretation**, in which every axiom holds. Missing business fields do not necessarily break consistency: a course without a recorded duration can still be possible. A contradiction is different. If two classes are disjoint, no individual can belong to both under those axioms. Declare disjointness only where the distinction is justified: a learner may also be an instructor, so those roles are usually not disjoint.

OWL reasoning is **monotonic**: adding premises preserves earlier logical consequences under the same semantics. Our absence-based eligibility policy is different: c2 can stop being eligible when a new unmet prerequisite is recorded. Operational systems therefore still need deletion, correction, and recomputation. Monotonicity describes a logical property, not a promise that the application's decision can never change.

> A query returning no match is an observation about the query's dataset and semantics. It is not automatically a statement that the relationship is false in the world.

=== II · RDF and semantic graphs | Reasoning strategies and OWL profiles
> **Architect track — optional on first reading.** Keep one practical point: SPARQL does not run OWL reasoning by itself. The following execution strategies and profiles explain implementation choices; continue to SHACL if you are still learning the basic model.

We have described conclusions such as “c1 is a LearningResource.” Now ask how software obtains and serves those conclusions. This section compares execution strategies and restricted OWL language profiles so that formal modeling can be connected to an implementable system.

### What reasoning does
**Inference** derives a statement from facts and rules. **Entailment** is the logical relationship between premises and consequence. A **reasoning regime** selects which consequences the system considers, such as RDFS or an OWL profile. SPARQL alone does not require a store to run every kind of OWL reasoning. [12, 16]

| Strategy | How it works | Engineering consequence |
|---|---|---|
| Materialization | Store derived facts in advance | Fast reads can require more storage and update work |
| Query rewriting | Expand a query using the schema | Avoid some stored closure; rewritten queries may grow |
| External reasoning | Compute selected consequences elsewhere | Flexible but requires synchronization and provenance |

A **closure** is the set of facts obtained by applying the selected inference rules until no rule adds another conclusion; this stopping condition is called a fixed point. With materialization, deleting an asserted fact requires checking whether each derived fact still has another justification. Do not delete all related inferences indiscriminately.

### Profiles are practical language subsets
The preceding table explained when or where conclusions are computed. We now ask a different question: how much of the OWL language does the model permit? A **profile** is a restricted subset designed around particular reasoning tasks. The three names below identify alternative subsets, not three stages that every system must execute.

OWL 2 **EL** supports important large-classification workloads with restricted constructs. **QL** is designed around efficient query answering using rewriting techniques. **RL** supports rule-oriented implementation. These profiles trade expressive freedom for computational properties; they are not quality rankings. **OWL 2 DL** supports richer description-logic modeling subject to structural restrictions; DL stands for description logic, explained below. [17]

A **description logic** is a family of formal languages for describing classes and relationships with well-defined reasoning tasks. **Classification** computes class hierarchy consequences. **Instance checking** asks whether an individual belongs to a class. **Satisfiability** asks whether a class could have an instance under the ontology.

### Select reasoning by a measurable need
For the catalog, simple subclass inference may be enough. Use an explicit eligibility query for a policy that depends on a complete prerequisite snapshot. Choose richer reasoning only if a required question depends on those semantics. Record the reasoner version, supported profile, ontology version, and whether results include asserted facts, inferred facts, or both.

=== II · RDF and semantic graphs | SHACL validates a chosen data graph
Reasoning tells us what follows from our definitions. The catalog has another need: reject or report a course record that lacks a usable title or duration. We now introduce SHACL for that acceptance check, using the baseline Course records as the data to inspect.

### Shapes describe acceptance conditions
**SHACL**, the Shapes Constraint Language, validates an RDF **data graph** against a **shapes graph**. A **node shape** targets selected nodes. A **property shape** checks values reached along a path. A **focus node** is the particular node being checked. A **validation report** records conformance and individual results. [5]

**Schema example — check baseline course and learner records.** The block below defines checks, not another course. `sh:` names SHACL terms, and `xsd:` names datatypes. Apply this shapes graph to catalog.ttl; do not substitute it for the catalog facts.

```turtle
@prefix ex: <https://example.org/> .
@prefix sh: <http://www.w3.org/ns/shacl#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

ex:CourseShape a sh:NodeShape ;
  sh:targetClass ex:Course ;
  sh:property [
    sh:path ex:id ;
    sh:minCount 1 ; sh:maxCount 1 ;
    sh:datatype xsd:string
  ] ;
  sh:property [
    sh:path ex:title ;
    sh:minCount 1 ; sh:maxCount 1 ;
    sh:datatype xsd:string
  ] ;
  sh:property [
    sh:path ex:durationMinutes ;
    sh:minCount 1 ; sh:maxCount 1 ;
    sh:datatype xsd:integer ; sh:minInclusive 1
  ] ;
  sh:property [
    sh:path ex:requires ;
    sh:class ex:Course
  ] .

ex:LearnerShape a sh:NodeShape ;
  sh:targetSubjectsOf ex:likesTopic, ex:completed ;
  sh:class ex:Person .
```

A Course needs exactly one plain-string id, one plain-string title, and one positive integer duration; every recorded requires target must be a Course. This shape does not establish uniqueness across different course resources or reject prerequisite cycles. LearnerShape separately checks subjects of likesTopic or completed for Person membership; cross-record learner identity reconciliation remains an intake responsibility. `minCount` and `maxCount` count the values reached along the path. This title rule accepts plain strings, not language-tagged titles, whose datatype is `rdf:langString`. Choose a deliberate multilingual title policy rather than accidentally rejecting translations.

The figure places the shape in an ingestion workflow: a candidate graph is checked before publication, and failing records produce a report or enter a repair queue. This is one architectural use of SHACL; the shape itself does not install the workflow.

@diagram validation

SHACL does not inherently block every database write. A pipeline can validate before publishing, a store may integrate validation, or a batch job may report violations later. Define which arrangement you use and what happens to invalid data. Class targeting and validation results also depend on the graph supplied to the validator; explicitly decide how entailment and inferred types are handled. Class targets already include instances of subclasses when the relevant rdfs:subClassOf triples are present in the data graph, even without a separate inference pass. Types derived through other reasoning need explicit configuration or preprocessing. [5]

=== II · RDF and semantic graphs | Validation and inference answer different questions
We have now seen OWL describe meaning and SHACL inspect submitted records. The following counterexamples put them side by side. Their purpose is to show why an apparently reasonable ontology can still accept incomplete records, and why a shape can pass a logically inconsistent model.

### A small counterexample
Imagine c2 has a title but no duration. An ontology can still consistently describe it as a Course. The CourseShape from the previous section reports a violation. Now imagine c2 has duration 90 and is also classified into two disjoint OWL classes. The simple shape may pass while the ontology is inconsistent. Neither mechanism replaces the other.

| Mechanism | Primary question | Example outcome |
|---|---|---|
| OWL axiom | What must follow, or can this interpretation exist? | Infer a broader class; detect disjoint-class inconsistency |
| SHACL shape | Does this supplied graph meet these conditions? | Missing duration produces a validation result |
| Database constraint | Is this write allowed by enforced storage rules? | Duplicate unique key rejects a transaction |
| Application policy | Is this action allowed in this context? | Recommend only courses with satisfied prerequisites |

### Cardinality can mean different things
An OWL minimum-cardinality restriction expresses that sufficiently many values exist in the interpretation; it is not a requirement that all those values appear as explicit submitted fields. A SHACL minimum count inspects values in the selected data graph under the validation configuration. A database property existence constraint acts on writes to the database. Similar words do not imply interchangeable behavior. [5, 14, 15]

### A quality workflow for the catalog
First parse RDF syntax. Then validate the candidate graph using the declared shape version. Check ontology consistency for the chosen reasoning regime. Run competency queries with expected answers. Publish only after identity and evidence review. Keep reports linked to the data snapshot and validation configuration.

A **closed shape**, using `sh:closed`, can restrict which properties are permitted on focus nodes, with appropriate ignored properties. This is a local validation decision, not a global conversion of OWL to closed-world logic. Cross-record uniqueness and temporal business rules may require additional SHACL-SPARQL (shape checks written using the query language introduced in Chapter 3) or application checks. [5]

> Ask “Which question does this rule answer, when is it executed, and what happens when it fails?” before selecting an enforcement mechanism.

### Connection to the next part
We have separated facts, logical meaning, and data acceptance. Next we query the baseline facts with SPARQL; the queries will state when they rely on recorded data rather than inferred or globally complete knowledge.

### Check your understanding
**Try first:** core questions for this chapter are 1, 3, 7, 8, 10, 12, 16, 17, 20. They cover its main concepts and application decision. Attempt the remaining questions as a second pass. Cover the next answer with a sheet or scroll it out of view while writing your prediction. Compare the explanation only after committing an answer.

This review follows the chapter's sequence: first read RDF statements, then distinguish definitions and their consequences from checks on submitted data. Use the unchanged catalog unless a question explicitly introduces a variation. Try explaining each answer before reading the explanation; you do not need SPARQL syntax yet.

### Review 1 · Read the representation
**Question 1: In the statement “c1 is about Graphs,” which terms are the subject, predicate, and object? Is the object always a literal?**

**Answer:** c1 is the subject, about is the predicate, and Graphs is the object. Here the object is a resource identified by an IRI, not a text value. In a duration statement, the object can instead be an integer-typed literal. Under RDF 1.1, subjects are IRIs or blank nodes, predicates are IRIs, and objects may be IRIs, blank nodes, or literals. The position tells you the term's role; it does not make every object a string.

**Question 2: What is the difference between “60” as a string and “60” typed as an integer?**

**Answer:** The string is a text value; the integer-typed literal has the integer datatype and denotes a numeric value. Identical visible characters do not make them interchangeable RDF terms. This matters when the duration shape requires an integer: text that looks numeric does not satisfy that datatype requirement merely because a person can read it as a number.

**Question 3: What do a semicolon, a comma, and the word “a” mean in the Turtle examples?**

**Answer:** A semicolon keeps the current subject and introduces another predicate. A comma keeps both subject and predicate and introduces another object. The keyword “a” abbreviates rdf:type, so “c1 a Course” asserts class membership. These are ways to write triples compactly; they do not create a different data model. Expand a compact fragment into individual subject–predicate–object sentences when the notation feels confusing.

**Question 4: If a file repeats an identical triple or rearranges its statements, does its RDF graph gain another fact or acquire an order?**

**Answer:** No. An RDF graph is a set of triples: repeating a triple does not create a second occurrence in that graph, and statement order is not part of the graph's meaning. If two completions must be distinguished or a learning sequence must be ordered, represent those distinctions explicitly. Repetition or file position cannot carry that information reliably.

**Question 5: Are Turtle and JSON-LD competing database models? How could two similar-looking fragments describe different graphs?**

**Answer:** They are serializations that can represent RDF. To decide whether fragments represent the same graph, compare their expanded RDF terms and statements. Prefixes and JSON-LD contexts determine which IRIs abbreviated terms denote. A JSON-LD value interpreted as an identifier differs from an ordinary string value. In this chapter, the two-topic Turtle variation and the one-topic JSON-LD fragment deliberately differ; they are not exact translations of one another.

**Question 6: Can a blank-node identifier be used as a stable cross-system course key? Does a named graph prove who supplied its facts?**

**Answer:** Neither follows from the RDF structure. A blank node identifies a resource without providing a global IRI; its local label is not a portable business identifier. A named graph associates a graph name with a graph within a dataset. That name does not, by itself, establish authorship, truth, or access rights. Use stable course identifiers and explicit provenance and access policies when those guarantees are needed.

### Review 2 · Follow the logical consequences
**Question 7: If c1 is a Course and Course is a subclass of LearningResource, what follows? Must every query service return that conclusion?**

**Answer:** Under RDFS entailment, c1 is also a LearningResource. Whether a query service exposes that consequence depends on its configured reasoning behavior. A service that matches only explicit triples may not return it unless it was stored explicitly. The axiom supplies the logical relationship; the implementation and configuration determine how consequences become available to queries.

**Question 8: Suppose about has domain LearningResource and someone records “Maya about Graphs.” Will RDFS reject that statement because Maya is a Person?**

**Answer:** No. RDFS domain supports inferring that Maya is a LearningResource from her use as the subject of about. Range similarly supports typing the object, Graphs, as a Topic. Domain and range are not field-validation rules. Maya being a Person does not, by itself, conflict with the inferred type. Detecting a logical conflict requires appropriate additional axioms; rejecting an unwanted submission requires an acceptance rule.

**Question 9: How do an ontology, ontology engineering, and a reasoner differ? Does every hierarchy express the same semantics?**

**Answer:** The ontology is the model of concepts, relationships, and commitments. Ontology engineering is the work of designing and maintaining it. A reasoner is software that computes consequences or checks logical properties using supported semantics. A taxonomy provides a hierarchy, but a broader-term link in a knowledge-organization vocabulary should not automatically be read as an OWL subclass axiom. Decide what the relationship means before choosing its formal representation.

**Question 10: Why does “Every Graduate completed a Course” differ from the chapter's equivalent-class definition of Graduate?**

**Answer:** The first statement supplies a necessary condition: being a Graduate requires the completion, but a completion alone does not establish Graduate membership. The chapter's teaching definition makes Graduate equivalent to Person intersected with “completed some Course.” It therefore supports both directions, including classifying a Person with a known Course completion as Graduate under suitable reasoning. This is an isolated logical example, not a real graduation policy or a new recommendation rule.

**Question 11: Does “all completed values are Courses” guarantee that a person completed at least one course?**

**Answer:** No. A universal restriction, allValuesFrom, constrains the kind of any values that exist; it does not require a value to exist. An existential restriction, someValuesFrom, requires at least one related value in the specified class. If a definition needs both existence and a restriction on every value, those are separate commitments. Do not read the word “all” as evidence that a submitted completion record is present.

**Question 12: If the catalog contains no completion linking Maya to c2, does OWL prove she never completed it?**

**Answer:** No. Under open-world semantics, the missing statement leaves that fact unknown unless other knowledge establishes a conclusion. The recommendation application can still use an explicitly declared policy over its recorded snapshot, treating only recorded completions as evidence. That operational decision does not turn the missing triple into an OWL proof of non-completion. Keep the logical question and the application decision separate.

**Question 13: In the mentor variation, a functional primaryMentor property has two different mentor IRIs as values. Is that automatically an error?**

**Answer:** No. OWL does not generally assume that different IRIs denote different individuals. A functional object property can force those mentor names to identify the same individual. If the two mentors are also asserted to be different, the claims conflict and can make the ontology inconsistent. This illustrates why an OWL functional property does not act like a database rule that simply rejects a second submitted field value.

### Review 3 · Choose and govern the reasoning
**Question 14: How do materialization and query rewriting differ? What must happen after an asserted fact is deleted?**

**Answer:** Materialization stores derived facts ahead of queries; query rewriting expands queries using schema knowledge so some consequences can be retrieved without storing them in advance. Each has storage, update, and execution tradeoffs. After a deletion, a materialized conclusion should remain if another valid justification still supports it. Systems must therefore track support or recompute appropriately, rather than deleting every related inference or retaining every old conclusion.

**Question 15: Are OWL EL, QL, and RL successive levels of quality? Should we always select the most expressive option?**

**Answer:** No. They are restricted language profiles designed for different reasoning tasks and computational properties. EL supports important classification workloads, QL is designed around query answering with rewriting, and RL supports rule-oriented implementation. Choose the semantics required by the competency questions and verify the implementation's support. For the catalog, simple subclass inference may be sufficient; a complete prerequisite policy still needs its stated data assumptions and execution mechanism.

### Review 4 · Test records without confusing the guarantees
**Question 16: Can a record pass logical consistency checking but fail the duration shape? Can the reverse happen?**

**Answer:** Yes to both. A course with no recorded duration can be logically consistent while failing a shape that requires a duration value. Conversely, a record can supply its title and positive integer duration yet belong to two classes declared disjoint; the simple field shape can pass while the combined ontology and facts are inconsistent. Each result is relative to the actual axioms, shapes, data, and configured processing. Consistency and conformance answer different questions.

**Question 17: Why does an OWL minimum-cardinality restriction not replace a SHACL minimum-count rule for a required field?**

**Answer:** The OWL restriction requires enough values to exist in a satisfying interpretation; it does not require all of them to be written as explicit submitted values. A SHACL minimum-count rule checks the values reachable along its path in the graph supplied for validation under the chosen configuration. If the ingestion contract requires a recorded duration, check that requirement directly. Do not assume the ontology's existence commitment fills the submitted field.

**Question 18: The title shape expects xsd:string, but a submitted title has an English language tag. Why can validation fail even though the title looks readable?**

**Answer:** A language-tagged string has datatype rdf:langString, rather than xsd:string. The shape checks the declared datatype requirement, not whether a human understands the displayed words. The chapter deliberately distinguishes the initial language-tagged fragment from the plain-string baseline. If multilingual titles are required, revise the title contract and its shapes deliberately instead of silently treating the two representations as identical.

**Question 19: Does a SHACL shape automatically block writes, and does a closed shape turn OWL into closed-world reasoning?**

**Answer:** No. Validation must be connected to a workflow: a pipeline may reject a candidate graph, a database may integrate validation, or a batch process may report problems after storage. A closed shape restricts permitted properties locally on its focus nodes, subject to its settings; it does not change OWL's global semantics. State when validation runs, which data and inferred types it sees, and what a violation causes.

### Apply the chapter to one incoming record
**Question 20: An incoming c2 record has a title but no duration. The ontology is consistent, and the course has not been published yet. What should the ingestion process conclude and do?**

**Answer:** Logical consistency alone is insufficient for acceptance. Parse the submitted RDF, validate the candidate graph with the declared shape version, and record the missing-duration violation. Under a policy that requires a conforming record before publication, hold the record for correction and rerun the checks after repair. A later passing shape establishes conformance to those rules, not that the duration is factually accurate. Preserve the data snapshot, validation configuration, and reports, and run the relevant consistency and competency checks before publication.

**Ready to continue:** You should be able to read a small RDF fragment, predict a simple RDFS consequence, explain why missing facts remain unknown in OWL, and choose a shape for a required submitted field. The next part introduces SPARQL to ask precise questions about the catalog; it will distinguish explicit data from any configured inferences.

=== III · Querying RDF | SPARQL patterns and variable bindings
> **Learning goals for this part:** Trace variable bindings, optional matches, paths, and duplicate rows; reproduce the baseline outputs; explain the completeness assumptions behind eligibility.

The baseline RDF file is ready, and we know how definitions and quality rules differ from facts. We can now ask our first data question: which courses are about Graphs? The query below reads the unchanged baseline; it does not insert facts or require OWL reasoning.

### Match a small piece of the graph
To execute the following queries, use Running the examples in the reader guide: save the complete query as lab/practice.rq and run the small Python runner there. SPARQL PREFIX declares the same IRI abbreviation as Turtle @prefix, but uses no @ sign and no ending period.

**SPARQL** is a query language and related protocol family for RDF. A **triple pattern** resembles an RDF triple but can contain variables. A **variable binding** assigns an RDF term to a variable for one solution. A **basic graph pattern** combines triple patterns by their shared variables. A **projection** selects which variables appear in the output. [4]

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
`SELECT` produces solution bindings. `ASK` produces a boolean indicating whether a solution exists. `CONSTRUCT` builds an RDF graph from matched solutions. `DESCRIBE` requests a resource description whose exact content depends on the service. Use CONSTRUCT when you need a predictable graph shape. [4]

**Baseline yes/no query — did Maya complete c1?** This independent ASK query checks one recorded connection and does not change the data.

```sparql
PREFIX ex: <https://example.org/>
ASK { ex:maya ex:completed ex:c1 }
```

Expected result: true. Without additional reasoning, this asks about the explicitly available query dataset. It is not a general proof about every possible external source.

=== III · Querying RDF | Walk through one query, row by row
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

=== III · Querying RDF | Optional data, filters, and duplicate results
Our first query required every requested fact to be present. Real catalogs often omit descriptions or give a course several topics. We now keep the same baseline and study how those situations affect query rows, so missing data and repeated answers do not become surprises.

### Preserve a course even when an attribute is absent
`OPTIONAL` adds matching bindings when available and preserves the current solution when the optional pattern has no match. An **unbound variable** has no RDF term assigned in that solution. It is not an RDF literal called null. [4]

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

=== III · Querying RDF | Paths, aggregation, and graph construction
The earlier queries returned course attributes. We now ask three different questions about the same baseline: which prerequisites are reachable, how many courses cover each topic, and how to return a new graph of candidate links. Each block is an independent query, not a step that modifies the next block.

### Reachability is different from enumerating routes
A SPARQL **property path** expresses a sequence or repetition of predicates. `ex:requires+` means one or more requires steps; `ex:requires*` also permits zero steps. A zero-length path can relate a node to itself. A path expression asks about connections; it does not generally return every intermediate node or every distinct route. [4]

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

=== III · Querying RDF | A policy-aware recommendation query
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
`NOT EXISTS` is evaluated relative to the outer bindings and active dataset. It implements a dataset-level test, not an OWL negative assertion. This query is sound for the declared policy only if the selected catalog contains all prerequisites relevant to the decision and the completion records are sufficiently complete for the user. [4]

A course with no recorded prerequisites passes the final test. This is **vacuous truth**: there is no prerequisite counterexample. If “unknown prerequisites” must be treated differently from “none required,” add an explicit review or completeness field and filter on it.

### Beyond a binary decision
A **ranking function** assigns scores to candidates. Keep eligibility separate from ranking. The example uses eligibility rules only; it does not learn user preference or optimize a statistical model. A production recommender might rank eligible courses by topic fit, recency, course quality, and diversity, then log the reason and evidence used for each recommendation.

=== III · Querying RDF | Named graphs, updates, and federation
So far, each query read one local baseline graph. We now step outside that exercise to show how a larger RDF service can separate source contexts, publish changes, and consult another endpoint. The following named-graph examples need additional dataset setup and are not baseline queries.

### Organize context explicitly
Use named graphs to separate source snapshots, assertion sets, or publishing stages. **Provenance** records origin and transformation history. A graph name can be a handle for provenance, but the meaning of that association is an application convention. Query default graphs and union graphs vary by service configuration; document the chosen dataset. [1]

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

SPARQL Update provides data modification operations, including insert, delete, and graph-management operations. A service can separate query and update endpoints or restrict update access. Transaction boundaries, isolation, and durability remain implementation concerns rather than promises inferred from the RDF model. [18]

### Query across services
A **federated query** combines information from multiple query services. SPARQL `SERVICE` evaluates a pattern at another endpoint. It can support integration without copying every source into one database, but network latency, permissions, timeouts, and inconsistent snapshot times complicate the result. Restrict service destinations; do not let untrusted users direct server-side requests to arbitrary network locations. [19]

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
**Try first:** core questions for this chapter are 1, 6, 8, 10, 15–17, 23. They cover its main concepts and application decision. Attempt the remaining questions as a second pass. Cover the next answer with a sheet or scroll it out of view while writing your prediction. Compare the explanation only after committing an answer.

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

**Ready to continue:** You should be able to trace shared variables, predict optional and duplicate results, distinguish a returned graph from an update, and explain a recommendation through its recorded evidence and policy assumptions. The next part rebuilds the same baseline in Neo4j and Cypher; a change of representation does not change Maya's starting facts.

=== IV · Property graphs and Cypher | Labeled property graphs from first principles
> **Learning goals for this part:** Represent the same catalog as labeled nodes and relationships; read Cypher patterns; reproduce equivalent policy results; identify what constraints do not enforce.

We now return to the same learners, courses, and recommendation question, but switch representation. The next chapters rebuild the baseline as a labeled property graph in Neo4j. No domain facts change merely because the syntax changes from RDF/SPARQL to graph patterns/Cypher.

### The model used by Neo4j
A **labeled property graph**, or LPG, has nodes, directed relationships, and properties. A node can have multiple labels. A relationship has a type, a start node, an end node, and can carry properties. A **property** is a named stored value on a node or relationship. Cypher uses patterns that resemble small graph drawings. [6, 20]

The figure shows the same c1-to-Graphs fact in two representations. The upper row uses an RDF predicate; the lower row uses an LPG relationship type. Course and Topic describe entity categories, while the connecting relation says the course is about that topic.

@diagram models

Cypher uses punctuation to draw a pattern. Parentheses enclose a node; square brackets inside an arrow enclose a relationship. A colon introduces a node label or a relationship type. This differs from the colon in RDF's ex:c1, which separates a prefix and local name. Braces hold key–value properties, and quoted text is a string. A name before a colon, as in (m:Person), is a query variable. The arrowhead gives direction. You can revisit the notation card in the reader guide at any point.

**Pattern illustration — one completion relationship.** This small drawing uses a score of 0.9 as an additional illustrative attribute. It is not an executable CREATE statement and it is not the full baseline loader.

```cypher
(:Person {id: 'maya', name: 'Maya'})
  -[:COMPLETED {score: 0.9}]->
(:Course {id: 'c1', title: 'Graph Basics'})
```

This is a pattern illustration, not a standalone write statement. `Person` and `Course` are labels. `COMPLETED` is the relationship type. `id`, `name`, `title`, and `score` are property keys. The arrow supplies direction. A query may match an edge without direction when either orientation is acceptable; the stored relationship still has a direction.

### Practical consequences
The score fits naturally on this particular completion relationship. But if there are repeated attempts, multiple evidence documents, or independent lifecycle rules, an event node can be clearer. Parallel relationships can connect the same two nodes with the same type; they remain distinct relationship instances. RDF duplicate triples do not represent repeated occurrences in the same way.

A label is a useful category, but adding `:Course` does not by itself supply OWL class semantics. Multiple labels do not automatically form a subclass hierarchy. Native properties are convenient values, not independent globally identified resources. Reify a value as a node when it needs its own identity or relationships.

> Property graphs make relationship instances and their attributes convenient. RDF makes globally identified statements and shared vocabularies convenient. Both can represent rich domain models.

=== IV · Property graphs and Cypher | Create the same catalog in Cypher
The previous section explained the property-graph picture. Now we create its baseline records. First protect stable IDs with constraints; then create nodes and connect them. The short excerpt below demonstrates the loading pattern, while catalog.cypher supplies the complete dataset.

### Establish identity constraints first
A **uniqueness constraint** prevents duplicate values within its declared scope. It also supports efficient identity lookup through its backing index. A uniqueness constraint alone does not require every matching node to have that property. In Neo4j 5, property existence, property type, and key constraints require Enterprise Edition. The Community lab uses property uniqueness constraints and pipeline validation for the remaining contract rules. Check deployment-specific availability for existence, type, and key constraints. [7]

**Baseline setup — protect the three kinds of node IDs.** Run these constraint statements in the exercise database before loading records. They prevent duplicate values within each declared label scope.

```cypher
CREATE CONSTRAINT person_id IF NOT EXISTS
FOR (p:Person) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT course_id IF NOT EXISTS
FOR (c:Course) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT topic_id IF NOT EXISTS
FOR (t:Topic) REQUIRE t.id IS UNIQUE;
```

### Build nodes, then connect them
MATCH finds existing elements that fit its pattern; MERGE matches or creates the stated pattern; SET assigns properties. In the reader guide, Running the examples shows how to open cypher-shell and load catalog.cypher. Run the following loader excerpt only to study its structure; load the complete file for baseline answers.

The following is an excerpt; the companion `catalog.cypher` contains the complete, rerunnable baseline. Run the statements in a dedicated empty exercise database the first time.

**Loader excerpt — create four nodes and their connections.** This intentionally omits Leo, the other courses, and other topics. Use the complete catalog.cypher file when reproducing all baseline counts and answers.

```cypher
MERGE (m:Person {id: 'maya'}) SET m.name = 'Maya';
MERGE (g:Topic {id: 'graphs'}) SET g.name = 'Graphs';
MERGE (c:Course {id: 'c1'})
SET c.title = 'Graph Basics', c.durationMinutes = 60;
MERGE (c:Course {id: 'c2'})
SET c.title = 'Graph Search', c.durationMinutes = 90;

MATCH (m:Person {id: 'maya'}),
      (g:Topic {id: 'graphs'}),
      (c1:Course {id: 'c1'}),
      (c2:Course {id: 'c2'})
MERGE (m)-[:LIKES_TOPIC]->(g)
MERGE (m)-[:COMPLETED]->(c1)
MERGE (c1)-[:ABOUT]->(g)
MERGE (c2)-[:ABOUT]->(g)
MERGE (c2)-[:REQUIRES]->(c1);
```

`MERGE` matches a pattern or creates it when absent. It is not a substitute for uniqueness constraints under concurrent writes. Prefer merging an entity by stable ID and setting mutable descriptive properties separately. A merge containing a mutable title can create unintended extra nodes after a title change. For relationships, bind their endpoint nodes first. [21]

An operation is **idempotent** if repeating it has the same intended effect as applying it once. This loading pattern is designed for repeatability on the exercise graph; production ingestion also needs concurrency, deletion, and retry policies.

=== IV · Property graphs and Cypher | MATCH, WHERE, RETURN, and parameters
Assume the complete Cypher baseline has been loaded. We will repeat two familiar catalog questions: find courses about Graphs, then find courses below a duration limit. Comparing the results with SPARQL helps separate the shared question from language-specific notation.

### Read a pattern as a sentence
Run a complete Cypher statement in the console described in Running the examples. Finish with a semicolon. For the parameterized query, set maxMinutes to 75 first using :param maxMinutes => 75 in cypher-shell.

`MATCH` finds patterns. `WHERE` filters matched candidates. `RETURN` projects values. The variable names `c` and `t` refer to matched graph elements inside the query; they are not persistent identifiers. [22]

**Baseline query — repeat “which courses are about Graphs?” in Cypher.** `c` names a matched course for this query; `t` names the Graphs topic. The RETURN clause requests the same columns as the earlier SPARQL query.

```cypher
MATCH (c:Course)-[:ABOUT]->(t:Topic {id: 'graphs'})
RETURN c.id AS id, c.title AS title
ORDER BY id;
```

Expected rows: c1 / Graph Basics and c2 / Graph Search. Compare this with the first SPARQL SELECT. The question and answers match even though the models encode categories and attributes differently.

**Baseline parameterized query — apply a duration limit.** Supply maxMinutes = 75 as a query parameter to obtain the expected result discussed below. The parameter is an input value, not a stored property.

```cypher
MATCH (c:Course)
WHERE c.durationMinutes <= $maxMinutes
RETURN c.id AS id, c.title AS title
ORDER BY id;
```

A **parameter**, such as `$maxMinutes`, is a value supplied separately by the client or query tool. With maxMinutes = 75, the baseline returns c1, c3, and c4. The companion duration query uses the same maxMinutes parameter; supply it in your query tool or client (the checker supplies 75). Applications should parameterize user-supplied values. Do not build query text by concatenating untrusted text.

### Index lookup versus graph expansion
An **index** is a lookup structure that can help find starting nodes by values. In the first query, a Topic ID lookup can be followed by expansion to connected courses. An index is not automatically needed for every relationship step, and adding one to every property is not a universal performance strategy. Read the execution plan for the actual query and distribution.

### Scope is part of correctness
A **clause** is a stage in a query. `WITH` carries selected variables and computed values to the next stage. Variables not carried forward leave scope. This makes complex Cypher queries easier to structure, but dropping a variable can change the question or make a later clause invalid.

**Baseline worked query — carry a grouped result forward.** The first clause matches course-topic associations. WITH groups by topic and counts distinct courses; WHERE keeps only counts above one.

```cypher
MATCH (c:Course)-[:ABOUT]->(t:Topic)
WITH t, count(DISTINCT c) AS n
WHERE n > 1
RETURN t.id AS topic, n ORDER BY topic;
```

The baseline returns graphs / 2. After WITH, only t and n remain in scope; c is no longer available. To use c later, the query would need a different stage design. Counting distinct c prevents repeated associations from counting the same course twice in this example.

**Isolated exercise:** begin with the complete baseline in the disposable database. Add a second topic to c2 using the first statement below. Run the second statement and predict the rows for c2; then use the last statement to remove only the added relationship. Other courses remain unchanged.

```cypher
MATCH (c:Course {id: 'c2'}), (t:Topic {id: 'data'})
MERGE (c)-[:ABOUT]->(t);
MATCH (c:Course {id: 'c2'})-[:ABOUT]->(t:Topic)
RETURN c.id AS id, t.id AS topic ORDER BY topic;
MATCH (:Course {id: 'c2'})-[r:ABOUT]->(:Topic {id: 'data'})
DELETE r;
```

Expected rows before cleanup: c2/data and c2/graphs. The result contains two topic associations, not two course entities.

=== IV · Property graphs and Cypher | OPTIONAL MATCH, null, and aggregation
The RDF chapter showed that missing summaries and multiple matches affect result rows. We now revisit those same situations in Cypher. Keep the baseline unchanged: Summary nodes are deliberately absent, so the first query demonstrates a missing optional match.

### Missing values need deliberate handling
`OPTIONAL MATCH` preserves the current row and supplies null for unmatched parts. **Null** represents an absent or unknown value in Cypher expressions. A missing property reads as null; setting a stored property to null removes that property. Null comparisons do not behave like ordinary true/false comparisons: use `IS NULL` when testing absence. [23, 24]

**Baseline query — keep courses without summary nodes.** HAS_SUMMARY and Summary are hypothetical optional structures. They are absent from the baseline, so this example tests what happens when the optional pattern finds nothing.

```cypher
MATCH (c:Course)
OPTIONAL MATCH (c)-[:HAS_SUMMARY]->(s:Summary)
RETURN c.id AS id, s.text AS summary
ORDER BY id;
```

The baseline has no Summary nodes, so all four courses appear with null summaries. An optional pattern with several matches produces several rows. Keep a filter that belongs to an optional pattern with that pattern; filtering after a later WITH can remove the preserved null rows and change the result.

### Count entities, not accidental rows
**Baseline query — count distinct courses for each topic.** This repeats the earlier SPARQL aggregation on the LPG representation.

```cypher
MATCH (c:Course)-[:ABOUT]->(t:Topic)
RETURN t.id AS topic, count(DISTINCT c) AS courses
ORDER BY courses DESC, topic;
```

Expected counts: graphs 2, data 1, ethics 1. `count(*)` counts rows, whereas `count(expression)` excludes null values. `DISTINCT` removes repeated values at the selected stage. `collect` builds a list of values; decide whether repeated values are meaningful before using DISTINCT inside it.

### A multiplication trap
If one course has three topics and two evidence documents, matching both relationships can produce six rows for the course. Summing its duration over those rows overcounts it. Aggregate each independent relationship set before combining them, use a subquery, or project distinct entities at the correct scope. This issue occurs in both SPARQL and Cypher because pattern matching combines multiple compatible solutions.

> The storage model does not define your counting unit. Write down whether you are counting courses, topic associations, completion events, or query rows.

=== IV · Property graphs and Cypher | Paths, cycles, and bounded expansion
The catalog says c2 requires c1. We now follow that relationship through possible chains and explain why a production query needs an intentional depth policy. The first query reads the baseline; the longer chains and cycles discussed afterward are hypothetical variations.

### Ask a bounded traversal question
A **variable-length path** matches a range of relationship counts. For a Neo4j 5-compatible example, `[:REQUIRES*1..5]` means between one and five REQUIRES relationships. A named path variable can be inspected with path functions. [22]

**Baseline query — follow c2's prerequisites up to five hops.** The variable p names the whole matched path; r names its reached Course node. We return distinct endpoint IDs, rather than every path.

```cypher
MATCH p = (c:Course {id: 'c2'})-[:REQUIRES*1..5]->(r:Course)
RETURN DISTINCT r.id AS required
ORDER BY required;
```

The baseline result is c1. This query intentionally limits depth; it is not equivalent to an unbounded transitive closure for every graph. If a valid prerequisite chain can be longer than five, it will omit distant requirements. A bound is an operational policy that must be appropriate for the domain.

### Endpoints and routes are different outputs
Returning `r` asks for reached entities. Returning `p` exposes matched paths, potentially many routes to the same endpoint. An **undirected match** ignores stored direction for matching; it is inappropriate if prerequisite direction carries meaning. Neo4j path matching also has relationship-reuse rules; do not assume it returns every possible route, including routes that reuse the same relationship.

### Detect and prevent bad prerequisite structures
A **cycle** returns to an earlier node. A **self-loop** connects a node to itself. A prerequisite cycle can make every course in the cycle depend on the others. Use an offline validation job or a write-time domain check that detects such structures. Requiring unique course IDs does not prevent cycles.

**Shortest path** means minimum path length under a chosen definition. **Weighted shortest path** minimizes accumulated cost rather than the number of hops. These are graph algorithm questions, not the same as proving educational eligibility. A route with few hops can still be unsuitable if prerequisites are missing.

### Operational guardrails
Choose starting nodes through selective keys. Bound depth, result size, and execution time. Test high-degree nodes, not just the tiny catalog. An unbounded traversal can expand rapidly even when the final result is small. Prefer current release documentation when adopting newer path syntax or match modes.

=== IV · Property graphs and Cypher | The equivalent recommendation in Cypher
We have the property-graph facts and the Cypher building blocks needed to answer Maya's question. The following query implements the same policy as the earlier SPARQL query on catalogs satisfying the stated cross-model data contract. Its expected answer is still c2, allowing us to compare meaning rather than syntax alone.

### Apply the policy under an explicit data contract
The baseline uses LIKES_TOPIC, ABOUT, COMPLETED, and REQUIRES relationships. The query first anchors on Maya as a Person and finds a shared topic. It requires a course id and title for display, then applies the three eligibility conditions: topic fit, no recorded completion, and no unmet recorded prerequisite. The learner and display checks are data-contract checks, not new ranking rules.

**Baseline query — the same eligibility policy, expressed in Cypher.** The outer pattern finds Maya through her Person label and id, then courses sharing a liked topic. The first WHERE line requires non-null course id and title. The two absence conditions remove completed courses and candidates with an unmet recorded prerequisite. Read those checks in code order before comparing the contract below.

```cypher
MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
      <-[:ABOUT]-(c:Course)
WHERE c.id IS NOT NULL AND c.title IS NOT NULL
AND NOT EXISTS {
  MATCH (m)-[:COMPLETED]->(c)
}
AND NOT EXISTS {
  MATCH (c)-[:REQUIRES]->(required)
  WHERE NOT EXISTS {
    MATCH (m)-[:COMPLETED]->(required)
  }
}
RETURN DISTINCT c.id AS id, c.title AS title
ORDER BY id;
```

Expected result: c2 / Graph Search. `EXISTS` subqueries ask whether a matching pattern exists, using variables from the surrounding query. Negating the outer prerequisite existence test excludes courses for which at least one unsatisfied requirement can be found.

### Compare meaning before comparing syntax
**When are the two queries equivalent?** Both return c2 on the baseline. Other catalogs must follow the same **data contract**, a stated set of identity, category, and field rules:
- Each Course has exactly one id and title, both plain strings, and matching course identity across representations.
- Every prerequisite target is a Course.
- The learner is explicitly recorded as Person in RDF and labeled Person in the LPG, with a defined mapping between the learner IRI and the label-scoped Person.id key.

The lab's SHACL shapes check field counts, datatypes, prerequisite classes, and learner membership. Cross-record uniqueness and cycles need separate checks. Neo4j Community enforces the declared label-scoped id uniqueness constraints; the intake pipeline must check the other contract rules. Person.id also permits an indexed learner lookup; ids do not have to be globally unique across unrelated labels.

Two details align malformed-record behavior. Mandatory SPARQL id/title patterns omit a course missing either value; Cypher's IS NOT NULL guards do the same. Both queries inspect every prerequisite target, including a malformed untyped target, rather than silently ignoring a requirement with the wrong category.

The topic match deliberately has no Topic type/label condition in either query. LearnerShape accepts subclass membership when the required subclass triples are present, but the raw queries require explicit Person membership. If inferred memberships are intended, make them available consistently before querying. One distinction remains outside the contract: two RDF titles produce two projected rows, whereas one LPG title property is a single value, possibly a list. Equivalent baseline results are not a guarantee of equivalence for arbitrary malformed data.

Both versions depend on completion-data completeness and a reviewed prerequisite snapshot. Neither proves a person lacks an unrecorded real-world qualification. Both can return duplicate candidate rows before DISTINCT if multiple liked topics match one course. Both need additional policy for retired courses, course editions, evidence freshness, and access restrictions.

### Build an explanation alongside the result
Return a separate explanation structure containing the shared topic, the required course IDs, completion-event IDs, and evidence-document IDs. Do not rely on a generated natural-language explanation to reconstruct the reason later. Log a policy version and data snapshot so the decision can be reproduced.

A useful user explanation would be: “Graph Search matches your interest in Graphs. Its recorded prerequisite is Graph Basics, which you completed.” The explanation must remain accurate when the ranking model changes. Eligibility, ranking, and explanation are separate artifacts even when one query gathers their inputs.

=== IV · Property graphs and Cypher | Constraints, transactions, and evolution
The queries explain how to read the application graph. We now shift to keeping it correct while people and importers change it. Use the catalog as the reference point: duplicate IDs, concurrent completion writes, and a later event-model migration are the problems being addressed.

### Enforce what the database can enforce
A **constraint** rejects states or writes that violate a declared rule. An **index** accelerates selected access patterns; a uniqueness constraint can own an index. Neo4j constraint types and availability differ by version and edition. Check support rather than assuming every deployment provides existence, type, and key constraints. [7]

A uniqueness constraint on Course.id prevents two Course nodes from storing the same ID. It does not guarantee that a course has a title, that a prerequisite is a Course, or that there are no prerequisite cycles. Those rules need supported constraints, domain checks, or pipeline validation. Use a rule inventory that names the enforcement mechanism and owner for each invariant.

### Transactions and concurrency
A **transaction** groups reads and writes with database-defined guarantees. **Atomicity** means its changes are all applied or all rolled back. **Consistency** means committed operations preserve enforced invariants, not that the content is true. **Isolation** describes interaction among concurrent operations. **Durability** concerns committed changes surviving failures under the system's guarantees. Together, atomicity, consistency, isolation, and durability form the transaction-property acronym **ACID**.

A **race condition** occurs when concurrent actions interact in an order-sensitive way. Two importers may both decide a node does not exist. Stable-key uniqueness constraints protect identity better than an application-side “check then create.” Retried operations must be designed not to duplicate completion events. [21]

### Evolve a model safely
Suppose completions move from direct relationships to event nodes. Introduce event IDs, backfill historical events where evidence permits, verify counts, change readers, then retire obsolete write paths. If historical timestamps are unknown, preserve that uncertainty rather than inventing dates.

A **migration** transforms data or schema between versions. **Backward compatibility** allows existing readers to continue working. A **derived projection** is a convenience representation computed from a more authoritative form. If direct COMPLETED edges are derived from Completion nodes, document rebuild rules and lag.

> “Schema optional” means you can begin with few declarations. It does not remove the need for a domain contract, migration plan, or quality controls.

### Connection to the next part
We can now represent and query the same baseline in both approaches. Next we extend the conceptual model itself, beginning with completion events, before considering mappings and architecture.

### Write a query before reading the solutions
Use the unchanged baseline and the reader-guide setup. These three tasks build on syntax already shown. Write and save your own query first, then compare it with the solutions below. The matching practice_queries file in lab contains the solutions as separate blocks; run one block at a time.
1. Recommend courses for Leo using the full policy. Expected: c3 / Query Patterns.
2. List the courses Maya completed, showing id and title. Expected: c1 / Graph Basics.
3. Count distinct courses per topic but exclude Ethics. Expected: Graphs 2 and Data 1, using the topic terms of this representation.

### Practice solutions — compare after trying
**Solution 1.** Only the learner changes in the eligibility query; Leo likes Data and completed c1.

```cypher
MATCH (m:Person {id: 'leo'})-[:LIKES_TOPIC]->(t)
      <-[:ABOUT]-(c:Course)
WHERE c.id IS NOT NULL AND c.title IS NOT NULL
AND NOT EXISTS {
  MATCH (m)-[:COMPLETED]->(c)
}
AND NOT EXISTS {
  MATCH (c)-[:REQUIRES]->(required)
  WHERE NOT EXISTS {
    MATCH (m)-[:COMPLETED]->(required)
  }
}
RETURN DISTINCT c.id AS id, c.title AS title
ORDER BY id;
```

**Solution 2.** Follow the recorded completion from Maya, then read that course's display fields.

```cypher
MATCH (:Person {id: 'maya'})-[:COMPLETED]->(c:Course)
RETURN c.id AS id, c.title AS title ORDER BY id;
```

**Solution 3.** Filter Ethics before grouping; the remaining groups count distinct course entities.

```cypher
MATCH (c:Course)-[:ABOUT]->(t:Topic)
WHERE t.id <> 'ethics'
RETURN t.id AS topic, count(DISTINCT c) AS courses
ORDER BY courses DESC, topic;
```

### Check your understanding
**Try first:** core questions for this chapter are 1, 4, 6, 10, 13, 15, 18, 20, 23. They cover its main concepts and application decision. Attempt the remaining questions as a second pass. Cover the next answer with a sheet or scroll it out of view while writing your prediction. Compare the explanation only after committing an answer.

This review follows the chapter from the property-graph model through Cypher queries to safe updates. Use the unchanged catalog unless a question explicitly introduces a variation. First predict the result or explain the rule in your own words, then compare your reasoning with the answer. Where the question revisits SPARQL, compare the intended meaning before comparing syntax.

### Review 1 · Read and load the property graph
**Question 1: In the completion pattern, which elements are labels, relationship types, properties, and variables?**

**Answer:** Person and Course are node labels that mark categories. COMPLETED is the relationship type connecting the person to the course. Fields such as id and title are properties, and the illustrative score belongs to the relationship. Names such as m and c are query variables referring to matched elements during that query; they are not durable identifiers. The arrow records the direction of the connection.

**Question 2: Does adding both Course and LearningResource labels define a subclass hierarchy?**

**Answer:** No. It marks that particular node with two labels. It does not declare that every Course is a LearningResource or install OWL reasoning. The domain model must define the intended relationship between categories, and the implementation must provide any required inheritance or inference behavior. Useful category markers and executable formal semantics are different things.

**Question 3: Can two COMPLETED relationships connect Maya to c1? Would they mean the same thing as repeating an RDF triple?**

**Answer:** An LPG can contain distinct relationship instances with the same endpoints and type. They can represent separate occurrences if the model gives them that meaning. Repeating an identical RDF triple in one RDF graph does not create another occurrence because that graph is a set. In either representation, repeated attempts need an explicit identity and history policy; accidental duplicate relationships are not automatically valid new attempts.

**Question 4: Why does the loader MERGE a course by its stable id and SET its title separately?**

**Answer:** The id supplies the intended identity match, while the title is mutable descriptive information. Including a mutable title in the MERGE pattern can cause a rename to stop matching the existing node and lead to an unintended creation attempt or constraint failure. Matching by a stable key and updating the description keeps those responsibilities separate. Uniqueness constraints still matter, especially with concurrent writers.

**Question 5: Is the loader excerpt the complete catalog? What does idempotent mean here?**

**Answer:** No. The excerpt omits some learners, courses, and topics; use catalog.cypher for the full exercise. Idempotent means repeating an operation has the same intended effect as applying it once. The loader is designed to avoid creating another copy of the same baseline nodes and relationships when rerun. That property does not, by itself, settle concurrent ingestion, deletion, or repeated real-world completion events.

### Review 2 · Trace a Cypher query
**Question 6: What do MATCH, WHERE, and RETURN do in the course queries?**

**Answer:** MATCH finds graph patterns, WHERE restricts the matches, and RETURN selects the output values. Matching Course nodes linked by ABOUT to the Graphs topic returns c1 / Graph Basics and c2 / Graph Search in the baseline. The pattern and filter define which rows qualify; projecting id and title decides what the reader sees. Omitting a variable from the output does not remove its role in matching.

**Question 7: With maxMinutes set to 75, which courses pass the duration query? Why supply this limit as a parameter?**

**Answer:** c1, c3, and c4 pass because their durations are 60, 75, and 45 minutes; c2 has duration 90 and does not pass. The comparison includes 75 because it uses “less than or equal to.” A parameter supplies an input separately from the query text. It lets the application vary the value without constructing query syntax by concatenating user input; it is not another stored course property.

**Question 8: If a WITH clause carries only a course id onward, can a later clause still use the earlier course variable?**

**Answer:** Not unless that variable was also carried forward or is introduced again appropriately. WITH defines what remains in scope and can introduce computed values or aliases. Dropping the course variable removes access to that earlier binding in the following ordinary query stages. Plan the variables each stage needs rather than assuming every name remains available throughout a long query.

**Question 9: Does an index replace traversal, and should every property receive an index?**

**Answer:** No. An index can help locate selective starting nodes, such as a topic identified by its id. The engine can then expand along relationships to connected courses. Adding indexes everywhere has storage and update costs and does not guarantee a better plan. Assess the actual query, execution plan, and data distribution; the tiny catalog does not establish production performance.

### Review 3 · Handle nulls, multiplicity, and counts
**Question 10: Why does the optional-summary query return all four courses even though no Summary nodes exist?**

**Answer:** The initial MATCH finds courses. OPTIONAL MATCH preserves those rows when it cannot find a matching summary structure and supplies null for the unmatched parts. Returning s.text therefore yields null alongside each course id. If several summaries match one course, several rows can result instead. Optional matching preserves a missing match; it does not promise exactly one row per course.

**Question 11: How should missing properties be tested, and what does setting a property to null do?**

**Answer:** Use IS NULL to test for an absent value. Ordinary comparisons involving null do not behave like comparisons between known values; for example, an equality comparison to null does not provide the intended absence test. Reading a missing property yields null, and setting a stored property to null removes it. Decide whether absence is acceptable, erroneous, or subject to a default before filtering rows.

**Question 12: Why can a filter after a later WITH remove courses preserved by OPTIONAL MATCH?**

**Answer:** Once the optional pattern has preserved a row with null values, a later filter still decides whether that row survives. A condition that requires a known optional value can exclude the null row. Keep predicates intended to constrain the optional match with that pattern, and distinguish them from conditions intended to reject whole result rows. Filter placement is part of the query's meaning.

**Question 13: What is the difference between count(*), count(expression), and count(DISTINCT c)?**

**Answer:** count(*) counts input rows, including rows with null in individual fields. count(expression) counts non-null evaluations of that expression. count(DISTINCT c) counts distinct non-null course values in its group. Thus four course rows with null optional summaries do not imply four existing summaries. The baseline topic query counts distinct courses and returns graphs 2, data 1, and ethics 1.

**Question 14: In a model extension, one course has three topics and two evidence documents. Why can a combined match produce six rows, and why is DISTINCT on a duration value a poor repair?**

**Answer:** Each topic match can combine with each evidence match, giving three times two compatible combinations. Summing the course duration across those rows repeats its contribution. Deduplicating numeric durations instead of course identities can wrongly merge contributions from different courses with the same duration. Aggregate independent relationship sets separately, use suitable subqueries, or deduplicate the intended entities at the correct stage.

### Review 4 · Follow prerequisites and explain eligibility
**Question 15: What does REQUIRES*1..5 mean, and what does the baseline path query return from c2?**

**Answer:** It matches paths containing between one and five REQUIRES relationships. The baseline returns the distinct endpoint id c1. A valid prerequisite more than five hops away is outside this query's bound, so the query is not a full transitive-closure query for every possible graph. Select a depth limit that fits the domain and make any resulting incompleteness explicit.

**Question 16: How does returning a path differ from returning a distinct reached course? Is ignoring direction safe for prerequisites?**

**Answer:** A path exposes the matched route; a reached course identifies an endpoint. Several routes can reach the same endpoint, so distinct endpoint results can be much smaller than the set of paths. Ignoring direction changes the question by allowing the matcher to follow stored relationships either way. Since “c2 requires c1” is different from “c1 requires c2,” prerequisite direction must be preserved when evaluating those requirements.

**Question 17: Does a shortest prerequisite path establish eligibility or prove the prerequisite graph is valid?**

**Answer:** No. Shortest path concerns minimum path length, or minimum accumulated cost in a weighted variant. Eligibility depends on the stated interest, completion, and prerequisite policy. Graph validity may also require rejecting cycles, self-loops, and wrongly categorized targets. A path can be short while a prerequisite is unmet, and a shortest-path result is not a substitute for those checks.

**Question 18: Read the nested NOT EXISTS recommendation condition in plain language. Why does c2 pass in the baseline?**

**Answer:** Exclude a candidate if there exists a recorded prerequisite for which Maya has no recorded completion. c2 requires c1, and Maya completed c1, so that unmet-prerequisite counterexample is absent. c2 also matches her Graphs interest and has no recorded completion by Maya. As with SPARQL, the decision depends on the selected records and completeness policy; it does not prove an unrecorded real-world qualification is absent.

**Question 19: What happens if c2 gains another matching liked topic or a new unmet prerequisite?**

**Answer:** In separate variations, another liked topic can generate another candidate row for c2; RETURN DISTINCT id and title collapses identical projected results. A new unmet prerequisite changes eligibility instead: c2 fails the absence-of-counterexample condition. These are different effects. Removing repeated output rows does not remove a real unmet requirement, and ranking a course highly does not make it eligible.

### Review 5 · Define the guarantees of a write
**Question 20: Does a unique Course.id guarantee a valid prerequisite graph or require every course to have an id?**

**Answer:** No. The uniqueness constraint prevents duplicate stored id values among Course nodes; by itself, it does not require each Course node to contain an id. It also does not ensure that REQUIRES targets are Courses, prerequisite lists are complete, or cycles are absent. Use supported existence or key constraints where appropriate, plus the necessary domain checks, and record which mechanism enforces each rule. Availability depends on version and edition.

**Question 21: What do ACID guarantees establish, and why can “check then create” still be unsafe?**

**Answer:** Atomicity groups changes so they apply together or roll back; consistency preserves enforced invariants; isolation governs concurrent interactions; durability concerns surviving failures under the database's guarantees. These properties do not establish that a recorded completion is factually true. Two importers can both observe an absent node before either creates it. Stable-key uniqueness constraints and an appropriate transactional write strategy address that race more reliably than a separate application-side existence check.

**Question 22: Why must retry behavior distinguish a repeated request from a genuinely new completion?**

**Answer:** A retry should not silently create a second event for the same intended operation, while a later real attempt may need its own event. Define event identity and idempotency according to that distinction. Reusing only the learner and course as identity can erase meaningful repeated attempts; creating a new identity on every retry can fabricate attempts. A MERGE keyword alone cannot decide the business meaning of those operations.

### Apply the chapter to a defective import
**Question 23: A faulty importer creates a unique Course node c5 and adds “c2 REQUIRES c5” and “c5 REQUIRES c2.” Does a successful commit certify the import as valid?**

**Answer:** No. Unique ids can coexist with this two-course cycle. A commit establishes compliance with the invariants actually enforced, not every rule the application intended. A cycle check should identify the defect, and the publication or write policy should determine how to reject or quarantine it. If those checks must prevent invalid states, their placement and transaction behavior must be designed accordingly. Restore the unchanged baseline after this hypothetical exercise.

**Question 24: What should be preserved when direct COMPLETED relationships are migrated to identified Completion events?**

**Answer:** Preserve the intended learner–course facts, stable event identities, and any supported evidence and timestamps. Backfill only what the historical records justify; keep unknown dates unknown. Verify the conversion, update readers and writers, and retire obsolete write paths deliberately. If direct edges remain as a derived projection, document how they are rebuilt, their update lag, and which event records are authoritative. The next chapter develops that event model in detail.

**Ready to continue:** You should be able to read and load the baseline property graph, predict the main Cypher results, explain null and row multiplicity, and separate uniqueness, domain validity, and transaction guarantees. We now extend the domain model itself rather than merely translating the same facts between query languages.

=== V · Modeling and interoperability | Model events when relationships have a lifecycle
> **Learning goals for this part:** Choose direct relationships versus identified events; retain evidence and context; describe what a mapping must preserve and who owns each authoritative fact.

Until now, “Maya completed c1” was a single direct link. We now deliberately extend the model because we want a score, a time, and evidence for that particular occurrence. The new event e1 and document d1 are additional records; they were not hidden in the baseline.

### A completion is more than a binary link
For the extension below, assume Maya completed c1 on 1 October 2026 at 09:00 UTC, received a score of 0.9 on a zero-to-one scale, and has supporting document d1. We call that occurrence e1. These are invented additional facts, introduced here for the first time.

A **binary relationship** connects two entities. An **n-ary relationship** involves more participants or roles. A completion can involve a learner, a course edition, an assessment, a timestamp, a score, and evidence. An **event node** gives that occurrence a stable identity. It also makes repeated attempts explicit.

In this extension, e1 identifies Maya's particular completion of c1. The figure separates that occurrence from the learner and course, then links it to evidence d1. Its arrows leave event e1 toward its learner, course, and evidence. This is a different structure from the earlier direct person-to-course completion link. The two code fragments below show RDF and LPG representations of the event structure.

@diagram event

**RDF model extension — describe event e1.** The learner and course IRIs still identify the existing entities. The new event holds the score, event time, and a link to evidence d1.

```turtle
@prefix ex: <https://example.org/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

ex:e1 a ex:Completion ;
  ex:learner ex:maya ; ex:course ex:c1 ;
  ex:score "0.9"^^xsd:double ;
  ex:at "2026-10-01T09:00:00Z"^^xsd:dateTime ;
  ex:evidence ex:d1 .
```

**LPG version of the extension.** This excerpt creates e1 and connects it to the existing learner and course. It shows the same event idea, but leaves the evidence link for the surrounding application to add. The two fragments are alternative representations, not two commands for one database.

```cypher
MATCH (m:Person {id: 'maya'}), (c:Course {id: 'c1'})
MERGE (e:Completion {id: 'e1'})
SET e.score = 0.9,
    e.at = datetime('2026-10-01T09:00:00Z')
MERGE (e)-[:LEARNER]->(m)
MERGE (e)-[:COURSE]->(c);
```

The RDF score is explicitly xsd:double to match the intended floating-point representation of the Cypher Float. An untyped Turtle decimal such as 0.9 would instead be xsd:decimal; a mapping must not silently equate the two datatypes.

These are extensions, not replacements automatically applied to the baseline. In production, add event identity constraints and evidence links. If a completion is revoked, retain the event and record its status when audit requirements demand history; derive the current completion link only from qualifying events.

### Choose by the questions
A single relationship property may be enough for one stable interaction. An event node becomes useful for attempts, evidence, approvals, temporal validity, or cross-event references. Both RDF and LPG can use the same event-centered conceptual model. This avoids treating the convenience of edge properties as the only modeling criterion.

=== V · Modeling and interoperability | Statements about statements and provenance
The event example gave a completion its own identity. We now ask where that record came from and which source supports it. This is a shift from describing a learner's activity to describing the origin and status of the claim about that activity.

### Facts need context
**Assertion provenance** answers who asserted a claim, from which source, when, and through which transformation. **Evidence** supports a claim; **confidence** estimates uncertainty under a declared method. Neither is automatically proof of truth. PROV-O offers standardized concepts for entities, activities, and agents involved in provenance. [25]

RDF 1.1 **reification** describes a statement using resources and properties such as `rdf:subject`, `rdf:predicate`, and `rdf:object`. Describing a statement does not itself assert that statement. The same described triple may correspond to multiple assertion events. An application must decide whether it is tracking a proposition, an assertion occurrence, or a real-world event. [16]

**Isolated statement-description fragment.** This describes the proposition Maya completed c1, using a claim identifier. It does not assert the completed triple by itself. The real-world event, the proposition, and a source's act of asserting it can have different identifiers.

```turtle
@prefix ex: <https://example.org/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
ex:claim1 a rdf:Statement ;
  rdf:subject ex:maya ;
  rdf:predicate ex:completed ;
  rdf:object ex:c1 .
```

For example, a document can claim the completion and another can dispute it without creating two real-world completion events. Record source support and review status on the appropriate assertion records; the fragment above only teaches how the proposition is described.

### Three modeling choices
| Pattern | Useful when | Watch for |
|---|---|---|
| Named graph | An assertion set shares source or publication context | Define what its name means and how graph access works |
| Claim / event node | Each occurrence needs identity and evidence | More nodes and joins, but explicit lifecycle |
| Statement annotation support | The chosen implementation supports a suitable statement model | Check exact syntax, semantics, and export behavior |

**RDF-star** historically refers to work on statements about statements. RDF 1.2 introduces triple terms and related reification facilities, but deployment support and syntax must be checked against a specific specification and engine version. This tutorial uses RDF 1.1-compatible event and claim modeling in its executable baseline. Do not copy older annotation syntax and assume it has identical RDF 1.2 behavior. [8]

### A practical evidence record
Returning to the new e1 record, consider the claim “Maya completed c1.” To make its origin traceable, store a claim ID, source document ID, page or span locator, extraction method, asserted time, reviewer status, and the referenced entity IDs. Distinguish source publication time, extraction time, and the time the event happened. If the document is replaced, preserve enough version information to reproduce the original decision.

An LPG relationship can carry a source ID and timestamp directly. If several sources support the same relationship, represent support separately instead of overwriting one source property with the latest observation.

=== V · Modeling and interoperability | Ontology design as an iterative discipline
Earlier sections introduced ontology constructs one at a time. We now put them into a design workflow: start with the catalog's questions, settle the meaning of Course and Completion, and choose only the rules that serve those questions. This section describes a process rather than new baseline data.

### A minimal engineering cycle
Begin with users and competency questions. Write a scope statement: this ontology covers course offerings, topics, prerequisites, completions, and evidence; it does not describe every aspect of education. Create a term list with definitions and examples. Resolve ambiguous terms before converting them into classes.

Choose whether “Course” means an abstract subject, a published edition, or a scheduled delivery. Mixing those levels is a common cause of contradictory completion records. Model roles explicitly: “instructor” may be a role a Person holds in one delivery, not a permanently disjoint kind of person.

### From definitions to rules
Write natural-language definitions first. Then decide which belong in an ontology, which in SHACL, and which in application policy. “Every completion has one recorded learner” is a useful input constraint. “A completion is an educational event” is a classification commitment. “A learner can access the next course only after a passing score” is an operational policy requiring context.

Use a **namespace**, a controlled identifier space, to publish terms. Write human-readable labels and comments. A **deprecation** marks a term as discouraged without deleting its historical meaning. A **version IRI** can identify a specific ontology release. An **import** brings another ontology into scope; review imported commitments because they can change entailments. [14]

### Review and regression
Maintain a small set of positive examples, negative input cases, and expected query results. A **regression check** catches behavior that changed after a modification. If a subclass relationship changes, rerun classifications, shapes, and application queries that depend on it. Do not review ontology changes only as text diffs.

Use lightweight vocabularies where sufficient. SKOS can organize topics; OWL class axioms can capture formal category constraints; SHACL can validate catalog records. These artifacts can coexist. Reuse a vocabulary because its meaning fits, not merely because its terms resemble yours. [13]

> A useful ontology is one whose definitions, consequences, and maintenance responsibilities are understood by the people who depend on it.

=== V · Modeling and interoperability | Map RDF and LPG without losing meaning
We have represented the catalog twice. Now suppose we must exchange data between those representations. The question is no longer whether both can describe c1; it is whether identifiers, languages, repeated events, and source contexts survive a conversion.

### Start with a declared mapping contract
A **mapping** states how one representation corresponds to another. A **round trip** exports data and imports it back. A mapping is **lossless** for a specified scope when it preserves all distinctions required by that scope. There is no single universally lossless “RDF to property graph” shortcut for every possible graph and application.

| RDF construct | Possible LPG representation | Required decision |
|---|---|---|
| Resource IRI | Node with unique iri property | Preserve the full IRI and identity scope |
| rdf:type | Node label or INSTANCE_OF edge | Retain class IRI; decide multiple-class semantics |
| Resource-valued predicate | Typed relationship | Avoid namespace collisions in relationship names |
| Literal-valued predicate | Property or value node | Preserve datatype, language, and multiplicity |
| Named graph membership | Context node or assertion metadata | Keep multiple assertion contexts distinct |
| Blank node | Scoped generated node key | Do not treat a local label as global identity |

### A subtle round-trip failure
Suppose c1 has both `"Graph Basics"@en` and a translated title. Mapping both to one string property discards a language distinction or overwrites a value. A list of strings may retain text while losing language tags. A value-node representation can preserve both. Similarly, mapping two predicates with different namespaces to the same relationship type `ABOUT` loses their distinct meanings.

### Relationship identity is asymmetric
An LPG can contain two COMPLETED relationship instances with identical endpoints, type, and properties. Mapping both to one RDF triple collapses them because the RDF graph is a set. Map repeated occurrences to identified events or claims. Conversely, an RDF graph can make statements about a property IRI; a bare LPG relationship-type name is not automatically an independently addressable domain node.

### Verify the contract
Test term counts by category, datatype and language retention, graph-context retention, parallel edges, blank-node scope, and reconstructed query answers. Comparing raw node and triple counts alone is not sufficient because valid transformations can change those counts while preserving meaning.

=== V · Modeling and interoperability | Integration architecture: one graph or two?
A mapping describes correspondence between representations. An architecture decides which representation owns the facts and how changes move between systems. We now use the catalog to compare single-store and dual-store designs, with particular attention to stale completions and conflicting edits.

### Three viable patterns
A **canonical model** is the authoritative representation for a defined concern. A **projection** is a derived view optimized for a workload. A **hybrid architecture** uses more than one model or storage engine with explicit responsibilities.

The figure illustrates the semantic-primary option: canonical RDF feeds a derived application graph through a versioned mapping. Reconciliation checks whether the projection still agrees with its source. This is one choice, not a requirement to maintain two stores.

@diagram hybrid

- **Semantic primary:** maintain canonical identities, vocabulary, and assertions as RDF; serve SPARQL directly or publish derived application views.
- **Application primary:** maintain operational entities and events in an LPG; export RDF where interoperability and vocabulary alignment are required.
- **Dual model:** maintain governed semantic data and an application graph, with a controlled transformation pipeline and reconciliation process.

### Avoid an accidental dual master
If both stores independently edit the same fact, conflict resolution becomes part of the product. Assign ownership at field or entity level. For example, the catalog controls prerequisites while the completion service controls completion events. An **outbox** records change events alongside authoritative writes for later delivery. For example, publishing catalog change 42 also records a message to update the application graph. A **watermark** records how far a consumer has processed the stream: watermark 41 means change 42 has not yet been acknowledged there. These are delivery concepts, not additional RDF syntax.

A **change data capture** pipeline transfers changes from a source. **Eventual consistency** permits temporary differences while updates propagate. The application must know whether a stale completion could lead to an incorrect recommendation. Use a freshness bound or a direct authoritative check for sensitive decisions.

### Reconcile more than counts
Compare stable IDs, key relationship sets, deleted records, mapping versions, and expected query answers. Make projections rebuildable. Keep a last-successful watermark and a recovery procedure. Price the second store's operation, on-call responsibility, data transfer, and migration burden before selecting a hybrid design.

R2RML standardizes mappings from relational data to RDF and can support materialized or virtual views. A **virtual graph** exposes mapped data without necessarily storing all RDF statements separately. Virtualization can reduce duplication but shifts query planning and availability dependencies toward source systems. [26]

### Connection to the next part
The modeling options are now explicit. The next part uses those options to compare strengths and make a requirements-based choice, instead of judging either technology by its terminology alone.

### Check your understanding
**Try first:** core questions for this chapter are 1, 2, 6, 8, 11, 15, 19, 20, 22. They cover its main concepts and application decision. Attempt the remaining questions as a second pass. Cover the next answer with a sheet or scroll it out of view while writing your prediction. Compare the explanation only after committing an answer.

This chapter extended the baseline: e1 is an identified completion event and d1 is its supporting document. They are not hidden records in the original lab. The questions below move from identifying an occurrence to preserving its evidence, mapping its representation, and deciding which system owns it. Explain what must survive each change before choosing a storage pattern.

### Review 1 · Give occurrences their own identity
**Question 1: What is lost if two completion occurrences become one RDF completion triple?**

**Answer:** The distinction between the occurrences is lost. “Maya completed c1” records a connection but does not distinguish two attempts with different times, scores, or evidence. An RDF graph contains only one copy of an identical triple. Preserve separate event identities and attach the relevant learner, course, time, score, and evidence to each occurrence. The same principle applies when exporting distinct LPG relationships that happen to have identical endpoints and properties.

**Question 2: When is a relationship property sufficient, and when is an event node preferable?**

**Answer:** A property can be sufficient when one stable relationship needs a simple attribute and no independent lifecycle. An event node becomes useful when an occurrence must be identified, referenced by other records, supported by several documents, approved, revoked, or distinguished from repeated attempts. Choose according to the questions and history requirements. Neither RDF nor LPG forces every interaction into one pattern; both can use the event-centered conceptual model.

**Question 3: Does the event e1 replace Maya or c1, and is the event model exclusive to RDF?**

**Answer:** No. e1 identifies the completion occurrence; Maya still identifies the learner and c1 still identifies the course. Links from the event specify their roles in that occurrence. Both RDF and LPG can represent those participants and roles. Changing a binary connection into an event structure changes how the occurrence is described, not the identity of its participants.

**Question 4: Does the LPG event fragment preserve every detail of the RDF event fragment automatically?**

**Answer:** No. The RDF fragment includes an evidence link to d1. The LPG excerpt creates the event and its learner and course links, but explicitly leaves the evidence link for the application to add. Both illustrate the event approach, yet the shown fragments are not complete, lossless translations of each other. Compare the actual fields and connections, rather than assuming matching event names guarantee equivalent content.

**Question 5: If a completion is revoked, should its event always be deleted?**

**Answer:** That depends on the retention and audit policy. Where history must remain explainable, retain the event and record its status and relevant change context. A derived current-completion link should then depend only on events that still qualify under the policy. Keeping the history does not mean treating a revoked event as current evidence of eligibility. Separate the historical occurrence from the application's present decision.

### Review 2 · Separate activity, assertion, and evidence
**Question 6: How does a completion event differ from an assertion that the completion happened?**

**Answer:** The completion event describes Maya's activity. An assertion occurrence describes a source or agent making a claim about that activity. Two documents can assert the same completion without describing two different completions. Conversely, two real attempts can have similar descriptions while remaining distinct events. Decide whether an identifier names the activity, the proposition being expressed, or a particular assertion before merging records.

**Question 7: Does describing a statement with RDF 1.1 reification assert that statement?**

**Answer:** No. Reification can describe a statement's subject, predicate, and object without asserting the described triple. An application might use that structure to record a disputed or rejected claim. The meaning of any additional assertion record must be explicit. Do not treat the presence of statement metadata as automatic evidence that the application accepts the statement as a fact.

**Question 8: What is the difference between provenance, evidence, and confidence?**

**Answer:** Provenance records origin and transformation history, such as who asserted a claim and how it entered the catalog. Evidence is the material offered in support, such as a particular document passage. Confidence estimates uncertainty under a stated method. None alone proves the claim true: a well-documented extraction can still be wrong, and a high score without a defined interpretation is not a substitute for evidence or review.

**Question 9: Why record event time, source publication time, and extraction time separately?**

**Answer:** They describe different moments. Maya may complete a course before a certificate is published, and the application may extract the claim later still. Substituting extraction time for completion time changes the domain fact. Preserve the source version and page or span locator as well, so a later reviewer can reproduce what evidence was available when the decision was made. Unknown times should remain unknown.

**Question 10: If two sources support one completion claim, why is overwriting a single source property inadequate?**

**Answer:** Overwriting retains only the latest source and loses independent support and its history. It also makes it difficult to withdraw one source while retaining another valid justification. Represent the support records separately when that distinction matters, with their own source references and context. A named graph can group assertions sharing context, but its name alone does not authenticate the sources or prove their claims.

### Review 3 · Engineer the domain model deliberately
**Question 11: Why define what “Course” means before creating more classes and properties?**

**Answer:** An abstract course, a published edition, and a scheduled delivery are different possible identity boundaries. Mixing them can make a completion appear to satisfy a prerequisite for the wrong edition or delivery. Write the intended meaning and competency questions first, then choose identifiers and relations that support it. More formal syntax cannot resolve an undefined distinction on its own.

**Question 12: Should “a completion is an educational event,” “one recorded learner is required,” and “a passing score permits access” be implemented in the same way?**

**Answer:** Not necessarily. The first is a classification commitment suitable for the conceptual model and, if needed, ontology axioms. The second is an input acceptance condition suitable for validation. The third is an operational policy that needs context, including what counts as passing and which course access is being decided. They can share vocabulary while requiring different execution and enforcement mechanisms.

**Question 13: How do a namespace, a version IRI, and deprecation support maintenance?**

**Answer:** A namespace provides a controlled identifier space for terms. A version IRI can identify a specific ontology release, allowing dependent systems to record which definitions they used. Deprecation marks a term as discouraged without erasing its historical meaning. These mechanisms help readers and applications interpret older records, but they still need a documented migration and compatibility policy.

**Question 14: Why review ontology imports and rerun regression checks after a hierarchy change?**

**Answer:** Imported axioms and changed subclass relationships can alter logical consequences, even if the original instance data is unchanged. Those consequences may affect classifications, validation targets, and query answers. Check representative positive cases, negative input cases, and expected competency results rather than reviewing only the edited text. Reuse an external vocabulary when its meaning fits the domain, not just because its labels look familiar.

### Review 4 · Test what a mapping preserves
**Question 15: What does “lossless mapping” mean, and must a lossless round trip preserve raw node and triple counts?**

**Answer:** Losslessness is relative to a declared scope: the mapping must preserve the distinctions and behavior required by that contract. It need not preserve raw counts because one entity or relationship can require several statements or nodes in another representation. Compare stable identities, values, context, occurrence distinctions, and reconstructed query answers. Equal counts alone cannot demonstrate semantic preservation.

**Question 16: What can be lost when English and translated titles become one string property or an untagged list of strings?**

**Answer:** One string can overwrite another title or erase the distinction between them. A list can preserve both texts while losing their language tags, and may also lose relevant datatype distinctions. The mapping contract must specify how each value's language, datatype, and multiplicity survive. Separate value records are one possible representation when ordinary properties cannot retain the required distinctions.

**Question 17: Why is mapping two different predicate IRIs to the same relationship type ABOUT risky?**

**Answer:** Their identical local names do not establish identical meanings. If their namespaces distinguish different predicates, collapsing both into ABOUT removes the information needed to reconstruct which relation was asserted. Preserve full predicate identity through an explicit mapping convention or suitable metadata. Similar caution applies to class labels: a convenient label should not silently replace the original class IRI and its meaning.

**Question 18: Which less visible distinctions should a round-trip fixture include?**

**Answer:** Include parallel relationship instances, multilingual and typed values, multiple assertion contexts, and blank nodes from separate source scopes. Local blank-node labels must not become global keys that accidentally merge unrelated resources. Check statements about property IRIs as well: an RDF property can itself be described, while a bare LPG relationship-type name is not automatically an independently addressable domain entity. Test the distinctions the application actually needs.

### Review 5 · Assign ownership and manage freshness
**Question 19: Does interoperability require maintaining both an RDF database and an LPG database?**

**Answer:** No. A semantic-primary design can serve RDF directly or publish derived views. An application-primary design can keep operational data in an LPG and export RDF where required. A dual-model design is another option, with a controlled transformation pipeline. Select the arrangement that meets the workloads and ownership requirements; operating a second store adds synchronization, recovery, and maintenance responsibilities.

**Question 20: What is an accidental dual master, and how should the catalog avoid it?**

**Answer:** It arises when both stores independently edit the same facts without clear authority or conflict rules. Assign ownership at a useful scope, such as the catalog owning prerequisites and a completion service owning completion events. Make downstream projections derive those facts through a defined mapping. Calling one store “canonical” is insufficient unless writers, conflict handling, and deletion rules honor that ownership.

**Question 21: What do an outbox and a watermark contribute, and do they remove all synchronization risk?**

**Answer:** An outbox records change events alongside authoritative writes so they can be delivered later. A watermark tracks how far a consumer has processed the stream. They support delivery and recovery design but do not automatically guarantee fresh projections, correct transformations, or duplicate-free handling. Consumers still need defined retry behavior, error recovery, and reconciliation against the authoritative data.

**Question 22: Why can a stale projection produce an incorrect recommendation, and what should reconciliation compare?**

**Answer:** It can omit a recent completion, retain a revoked completion, or miss a new prerequisite. Define an acceptable freshness bound or consult the authoritative source before decisions that require fresher evidence. Reconciliation should compare stable IDs, important relationship sets, deleted records, mapping versions, and expected answers, rather than only counts. A rebuild procedure and last-successful watermark help recover a projection that has drifted.

**Question 23: Does a virtual RDF graph eliminate dependence on the source system?**

**Answer:** No. It exposes mapped data without necessarily storing a separate copy of every RDF statement, which can reduce duplication. Query planning, performance, and availability can then depend more directly on the underlying sources and mapping layer. R2RML standardizes relational-to-RDF mappings; it is not a universal RDF-to-LPG conversion standard. Choose virtualization according to those operational dependencies and the required semantics.

### Apply the chapter to a proposed shortcut
**Question 24: An exporter turns two attempts into one completed triple, keeps only the latest source, and replaces unknown historical dates with today's date. Is a matching course count enough to accept the export?**

**Answer:** No. It has collapsed occurrences, discarded independent source history, and invented event times. Matching counts cannot repair those losses. Preserve separate event identities and support records, represent unknown dates honestly, and state which current-completion links are derived under the policy. Test the reconstructed attempt history, evidence references, and relevant query answers before accepting the mapping. A summary view can intentionally omit detail only when its limited purpose is explicit and the authoritative detail remains available where required.

**Ready to continue:** You should be able to distinguish an event from a claim about it, choose where evidence belongs, define a mapping's preservation contract, and assign authority and freshness responsibilities. The next part uses these modeling choices to compare complete architectures against actual requirements.

=== VI · Strengths, tradeoffs, and decisions | Comparison: model and semantics
> **Learning goals for this part:** Compare complete candidate systems by requirement; distinguish hard requirements from weighted preferences; record an evidence-based architecture decision.

You have now seen both representations, their queries, and a mapping between them. The table below consolidates those observations by layer. Read it as a comparison of modeling choices and execution responsibilities, rather than a scorecard declaring a universal winner.

### Compare capabilities at the right layer
The table describes common strengths and modeling defaults, not an absolute limit on every implementation. A database can add features beyond its core data model, and an application can impose conventions on either approach.

| Dimension | RDF / semantic stack | Neo4j LPG / Cypher |
|---|---|---|
| Fundamental unit | Subject–predicate–object statement | Node and relationship instance with properties |
| Identifier culture | Shared IRIs are central | Application keys are central; IRIs can be retained |
| Edge attributes | Claim nodes, events, graph context, or supported annotation facilities | Relationship properties are direct and convenient |
| Formal semantics | RDFS / OWL offer standardized meaning and entailment | Domain semantics need explicit modeling and execution choices |
| Ontology usage | Natural fit for published vocabularies and reasoning | Possible through metadata, conventions, or additional tooling |
| Validation | SHACL evaluates a supplied graph | Native constraints plus domain and pipeline checks |
| Query style | Triple patterns and variable joins | Node / relationship patterns and clauses |
| Multiplicity | Identical triples form one set element | Parallel relationship instances are possible |
| Interchange | Several standardized RDF serializations | Export conventions and model mapping must be specified |
| Schema evolution | Flexible statements; semantic changes require care | Flexible graph structure; labels and properties still need governance |

### Two misleading slogans
“RDF is only for the web” is too narrow: global identifiers and shared vocabularies can help internal integration. “Property graphs have no semantics” is also too strong: domain meaning can be rigorously documented and enforced. The important distinction is whether meaning is represented through portable formal standards and whether the selected runtime executes those semantics.

A **semantic knowledge graph** often combines RDF, vocabularies, ontologies, and provenance. An LPG can also function as a knowledge graph. The choice should turn on required guarantees and workflows, not which label sounds more sophisticated.

=== VI · Strengths, tradeoffs, and decisions | Strengths and weaknesses in practice
The comparison table lists capabilities. We now connect them to practical situations: a catalog shared across independent systems, or an application that frequently records interactions and follows relationships. Each strength is useful only when it meets a requirement in that situation.

### When the semantic stack is especially useful
RDF is attractive when many sources must refer to shared entities and exchange meaning across system boundaries. Published vocabularies, formal class definitions, and standardized query patterns help when the meaning must outlive one application. Ontology reasoning can derive classifications and reveal logical conflicts. SHACL can make graph exchange contracts explicit.

The costs include a learning curve across several standards, careful namespace and identity governance, extra modeling for assertion occurrences, and implementation-dependent reasoning and transaction features. Overly expressive ontologies can be harder to understand and operate than the problem requires. RDF syntax does not automatically solve entity resolution, bad source data, or poor domain definitions.

### When the property graph approach is especially useful
An LPG is attractive when the central workload is an application following and explaining relationships, recording interactions, or calculating graph features. Cypher patterns can closely resemble the domain picture. Relationship properties make scores, timestamps, and weights straightforward when the relationship instance is the correct modeling unit.

The costs include designing durable identity and exchange conventions, governing domain meaning, and building validation beyond the selected database's native constraints. An ontology represented in the graph does not execute itself. Product-specific procedures, extensions, and operational features can increase migration effort. Simple-looking traversals can still be expensive on highly connected graphs.

### Shared obligations
Both approaches need a data contract, access controls, migration planning, benchmarks, backups, monitoring, and human ownership. Both can support recommendation and graph RAG. Both can be deployed badly. Neither guarantees reliable answers merely because relationships are explicit.

**Illustrative fit:** a course application with one owned catalog and frequent interaction updates may begin naturally with an LPG. A cross-institution course exchange with published vocabularies and classification requirements may begin naturally with RDF. These are hypotheses to validate against actual requirements, not categorical verdicts.

> A strength matters only when it satisfies a requirement. A feature that nobody uses can still impose maintenance cost.

=== VI · Strengths, tradeoffs, and decisions | A requirements-first decision framework
We can describe tradeoffs, but a project still needs a decision. This section turns the catalog's needs into a sequence of checks. Begin with conditions that cannot be compromised, then compare the candidates that satisfy them.

### Begin with hard requirements
A **hard requirement** is a condition a candidate must satisfy; a weighted score cannot compensate for failing it. Examples include required interchange formats, explicit reasoning semantics, a measured latency target, residency rules, or supported recovery procedures. A **soft preference** improves suitability without being mandatory.

Read the figure as a first branching question, not an automatic verdict. Shared formal meaning makes the semantic candidate worth evaluating; application traversal makes the LPG candidate worth evaluating. Both branches still require benchmarks and an operational review.

@diagram decision

### Ask these questions in order
1. Which questions and transactions must the system execute? Specify outputs, volumes, update rates, and concurrency.
2. Which facts need shared identifiers and portable formal definitions? Is OWL reasoning required, or would a controlled vocabulary suffice?
3. Which rules must reject writes, which may report violations later, and which are decision policies?
4. Which deployment options meet security, recovery, skills, and budget requirements?
5. What representative prototype would disprove the preferred option?

### Make the comparison falsifiable
A **proof of concept** is a bounded experiment, not a scaled-down product launch. Give both candidates the same conceptual facts, expected answers, policy, concurrency, and resource envelope. Record any materialized inferences, denormalized shortcuts, or projections used. If one candidate includes precomputation and the other does not, report that difference.

An **architecture decision record**, or ADR, preserves context, candidates, evidence, decision, consequences, and revisit triggers. A good revisit trigger is observable: “External consumers require published SHACL shapes and stable IRIs,” or “Prerequisite query response time exceeds the service target at twice current load.” “The technology is popular” is not a sufficient decision criterion.

=== VI · Strengths, tradeoffs, and decisions | A worked scoring matrix and ADR
The decision framework becomes clearer with a worked scenario. Assume one team owns the catalog and prioritizes an interactive recommendation service. We will score two hypothetical candidates, then write an architecture decision record that makes the assumptions and remaining tests visible.

### An illustrative application decision
Assume a small team owns the catalog, no external RDF interchange is mandatory, and the first release emphasizes interactive recommendation queries. Scores below are invented teaching values on a 1–5 suitability scale, where 5 is best. They are not benchmark results or universal product ratings.

| Criterion and weight | RDF candidate | LPG candidate |
|---|---|---|
| Application query fit · 30% | 4 | 5 |
| Team delivery readiness · 25% | 2 | 4 |
| Semantic exchange · 20% | 5 | 3 |
| Operational fit · 15% | 3 | 4 |
| Lifecycle cost · 10% | 3 | 3 |
| Weighted total | 3.45 / 5 | 4.00 / 5 |

Weighted score = sum of each criterion's weight multiplied by its suitability score. Weights sum to one. The LPG hypothesis wins under these assumptions. Raise semantic exchange to a hard requirement for formal published ontology services, and the decision process must change; a numerical total cannot override that requirement.

### Example ADR
**Context:** the application recommends courses from one controlled catalog and logs completion events. The team has experience with Cypher and needs a working service soon. Stable IDs, evidence, and export are still required.

**Decision:** prototype an LPG as the operational graph. Keep canonical IRIs and an explicit domain model. Validate title, duration, prerequisite cycles, and evidence in the ingestion pipeline. Define an RDF export contract rather than promising automatic lossless conversion.

**Evidence required before production:** identical expected query answers, target latency under representative load, retry-safe ingestion, access-control verification, and a restore exercise.

**Consequences:** application traversal is convenient, but shared ontology execution and semantic exchange need deliberate additional work. Revisit when formal inference or external RDF consumers become binding requirements.

**Sensitivity check:** change team-readiness and semantic-exchange weights. If a small change reverses the result, treat the decision as uncertain and run a more informative prototype rather than presenting the score as objective truth.

=== VI · Strengths, tradeoffs, and decisions | Explain the decision to stakeholders
The previous sections built the evidence behind a technology decision. We now practice explaining that reasoning to another person. The sample explanations show how to communicate assumptions, evidence, and limitations to stakeholders. Adapt them to actual work; they are not claims about projects you personally performed.

### A clear answer to “Why Neo4j for a recommender?”
A defensible answer ties the choice to an implemented workload: “My application needed to traverse user–item–topic relationships, record interactions with attributes, and produce understandable recommendation reasons. I selected a property graph because that model and Cypher fit those queries and the team's experience. I would verify performance with representative data rather than claim that property graphs are always faster.”

Continue with the tradeoff: “If the central requirement were cross-source semantic interoperability, published vocabularies, or formal ontology reasoning, I would evaluate an RDF stack. I would also consider a governed semantic layer with a derived application graph if both requirements justified the additional operational cost.”

### A clear answer about RDF experience
Separate practical experience from conceptual understanding. If you have not deployed RDF in production, say so directly: “My hands-on project work has been with Neo4j. I understand the RDF model and the roles of SPARQL, OWL, and SHACL, and I have worked through small examples. I would validate implementation-specific behavior in a prototype before committing to a production design.” Adapt that statement to what you have actually done.

### Explain ontology in one minute
“An ontology is an explicit domain model: its concepts, relationships, and, when formalized, logical axioms. It is not itself an algorithm. A reasoner is software that applies formal semantics. Ontologies can guide either RDF or property-graph systems, but storing ontology-like structures in a property graph does not automatically give them OWL reasoning behavior.”

### Handle the strongest follow-up
If asked “Which is best for us?”, ask for the important requirements within the discussion: shared semantics, supported queries, inference, validation, change rates, operational constraints, and existing skills. Then explain the decision framework and propose a bounded comparison. A strong answer acknowledges uncertainty while giving a concrete way to resolve it.

Avoid claims such as “RDF cannot do recommendations,” “Neo4j has no schema,” “OWL validates required fields,” or “one graph model always performs better.” Each confuses a modeling capability with implementation or policy.

### Connection to the next part
A clear explanation is only as strong as its evidence. The next part supplies the performance, recovery, governance, and security questions needed to test the proposed architecture.

### Check your understanding
**Try first:** core questions for this chapter are 1, 6, 7, 10, 12, 14, 16, 17, 20. They cover its main concepts and application decision. Attempt the remaining questions as a second pass. Cover the next answer with a sheet or scroll it out of view while writing your prediction. Compare the explanation only after committing an answer.

This chapter moved from understanding the models to choosing a complete architecture. The questions below follow that decision process: identify the relevant capabilities, separate binding requirements from preferences, test candidates, and explain the result. The scoring values are teaching assumptions, not measured product ratings. Use the stated scenario rather than treating either technology as the default winner.

### Review 1 · Compare the right capabilities
**Question 1: Why is a model-comparison table insufficient to select a production database?**

**Answer:** A data model describes representation, while a working system also depends on its implementation, configuration, reasoning support, validation workflow, and operations. Two RDF implementations can have different operational characteristics, and different Neo4j versions or editions can expose different features. Use the table to identify relevant questions, then evaluate concrete candidate stacks against the workload and required guarantees.

**Question 2: Is RDF useful only when data is publicly published on the web?**

**Answer:** No. Shared identifiers, vocabularies, and formal definitions can also support internal integration across independent systems. A public web application is not a prerequisite for those needs. The relevant question is whether the project benefits from those identity and semantic conventions and can govern them effectively, rather than whether its users browse the graph through a website.

**Question 3: Does choosing an LPG mean abandoning semantics or an ontology?**

**Answer:** No. A property-graph application can have precise domain definitions, ontology-guided modeling, and explicit validation and reasoning components. What it does not gain automatically is OWL execution from node labels or ontology-shaped records. Compare how each candidate represents meaning and which component actually applies it. Documented meaning and standardized executable semantics are related but distinct requirements.

**Question 4: When does the semantic stack have a particularly strong fit, and what work remains?**

**Answer:** It is especially worth evaluating when independent sources need shared identities, published vocabularies, formal classification, and explicit exchange contracts. RDF, RDFS/OWL, and SHACL provide relevant standardized building blocks. The team still needs entity resolution, suitable definitions, namespace governance, implementation selection, and operational testing. Standards make parts of the contract portable; they do not make inaccurate source records or ambiguous terms disappear.

**Question 5: When does an LPG have a particularly strong fit, and what work remains?**

**Answer:** It is especially worth evaluating for applications centered on relationship traversal, interaction records, and explainable graph patterns. Relationship properties can be convenient when the relationship instance is the right modeling unit. Durable identity, exchange mappings, domain validation, access control, and migration policies still need deliberate design. A readable Cypher query does not establish good performance on a highly connected production graph.

### Review 2 · Separate binding conditions from preferences
**Question 6: May a high weighted score compensate for a failed hard requirement?**

**Answer:** No. A hard requirement is a condition of acceptability. A candidate that fails it should not win through strengths in unrelated preference categories. First establish which candidates meet every binding condition, then compare their preferences. If no candidate qualifies, investigate a different architecture or seek an explicit revision of the requirement; do not hide the failure inside an average score.

**Question 7: How can a vague goal such as “the recommender must be fast” become a testable requirement?**

**Answer:** Specify the relevant query or transaction, representative data and update conditions, concurrency, resource envelope, and an acceptance threshold. State how the measurement will be taken and what counts as failure. “Fast” alone leaves different readers imagining different workloads. A measured latency requirement becomes a hard gate only when its scope and acceptance conditions are defined and binding.

**Question 8: If RDF export is mandatory, does that automatically rule out an application-primary LPG?**

**Answer:** No. A candidate can include a governed RDF export if it satisfies the required identifiers, vocabularies, values, context, and delivery contract. That is different from requiring a live service with specified formal inference or query semantics. Identify the exact obligation, then test the whole candidate architecture. Do not confuse requiring an output format with requiring every operational fact to be stored natively in that format.

**Question 9: Is a controlled topic vocabulary always a reason to adopt a rich OWL ontology?**

**Answer:** No. Determine what the competency questions require. A controlled vocabulary or lightweight concept organization may be sufficient for agreed topic terms and navigation. Richer OWL commitments become relevant when the required answers depend on their formal consequences. Extra expressiveness can add modeling and operational costs without improving the application if nobody needs those consequences.

### Review 3 · Use scoring as a transparent aid
**Question 10: How is the RDF candidate's illustrative score of 3.45 calculated?**

**Answer:** Multiply each suitability score by its weight and add the contributions: 0.30 × 4 + 0.25 × 2 + 0.20 × 5 + 0.15 × 3 + 0.10 × 3 = 3.45. The weights sum to one, so the result remains on the stated 1–5 scale. The calculation is reproducible arithmetic; the chosen scores and weights remain assumptions that need justification.

**Question 11: What does the LPG candidate's score of 4.00 establish, and what does it not establish?**

**Answer:** It establishes that the LPG candidate scores higher under this example's weights and assigned suitability values. It does not establish measured superiority, a universal ranking, or production readiness. The scenario assumes one owned catalog, relevant team experience, and no mandatory external RDF interchange. Changing those conditions can change which candidate is appropriate even when the arithmetic is correct.

**Question 12: What is a sensitivity check, and why does a narrowly winning score call for caution?**

**Answer:** A sensitivity check changes plausible assumptions, such as weights or uncertain suitability scores, and observes whether the decision changes. If small plausible adjustments reverse the ranking, the evidence does not strongly separate the candidates. Identify the uncertain criterion that matters most and design a more informative prototype. Adding decimal places to the total does not make uncertain judgments more accurate.

**Question 13: Can team familiarity count in the comparison, or is it irrelevant to architecture?**

**Answer:** It can matter because delivery time, support capacity, and maintenance depend on available skills. Record it as a contextual criterion rather than treating familiar syntax as proof of better semantics or performance. If training, hiring, or operational support can change the situation, include those costs and options. A decision for one team need not be the right decision for another.

### Review 4 · Design evidence that could change the decision
**Question 14: What makes a proof of concept informative rather than a demonstration of the preferred tool?**

**Answer:** It tests a bounded uncertainty with declared acceptance conditions and a result that could disprove the preferred option. Give candidates equivalent conceptual facts, expected answers, policy, and representative operating conditions. Select cases that challenge correctness and operational fit, not only the easiest graph pattern. A successful small experiment supports only the claims it actually tested; it is not a scaled-down production approval.

**Question 15: Is a comparison fair if one candidate precomputes inferences and the other recomputes them for every query?**

**Answer:** The designs can be compared, but that difference must be explicit. Precomputation can trade faster reads for storage, ingestion work, and update or refresh costs. Report those costs and ensure the candidates provide equivalent answers and acceptable freshness. Comparing only query latency while concealing different preparation and maintenance work can produce a misleading conclusion.

**Question 16: Why should the team test expected answers before treating a faster result as a success?**

**Answer:** A query that omits a prerequisite condition or reads a stale projection can be fast while answering a different question. Establish semantic equivalence through expected outputs, counterexamples, and the same completeness assumptions. Then measure performance under the declared workload. Correctness is part of the acceptance contract, not a preference that response speed can compensate for.

### Review 5 · Record and communicate the decision
**Question 17: What belongs in an architecture decision record, and what makes a useful revisit trigger?**

**Answer:** Record the context, requirements, candidates, evidence, decision, consequences, and conditions for revisiting it. A useful trigger is observable, such as external consumers requiring a specific ontology service or a prerequisite query breaching its target at a stated load. “Reconsider someday” gives no clear action point. The ADR should let another reader understand both why the choice was reasonable and when its assumptions stop holding.

**Question 18: If an LPG is selected for the catalog, which semantic and operational responsibilities remain?**

**Answer:** Stable identifiers, domain definitions, validation, evidence, and a tested exchange contract remain necessary. The example also requires representative latency measurements, retry-safe ingestion, access-control verification, and a restore exercise before production. Choosing an operational graph does not remove those obligations or establish that they are already complete. Record the owners and remaining evidence rather than presenting the selection itself as validation.

**Question 19: How should someone explain a Neo4j choice or limited RDF experience without making unsupported claims?**

**Answer:** Connect the choice to the actual workload, modeling needs, team skills, and evidence gathered, then explain the tradeoffs and conditions that would favor an RDF stack. Separate hands-on implementation experience from conceptual understanding and tutorial exercises. Do not borrow the chapter's sample wording as a claim of work never performed. A credible answer can acknowledge a limitation while proposing a concrete prototype to resolve the remaining uncertainty.

### Apply the framework to a changed requirement
**Question 20: The LPG candidate leads the weighted table, but a new binding requirement demands a service with specified formal ontology reasoning. What should happen next?**

**Answer:** Reopen the hard-requirement assessment for complete candidate architectures. Determine exactly which semantics, interfaces, and correctness guarantees are required, then verify whether each stack, including any additional reasoning component, can provide them. Exclude candidates that cannot qualify; do not preserve the old winner merely because its total was higher. If a hybrid design is proposed, include mapping fidelity, synchronization, freshness, and operating cost in its assessment. Update the ADR with the changed requirement, evidence, and remaining tests.

**Ready to continue:** You should be able to distinguish a model capability from an implemented guarantee, apply hard gates before preference scoring, explain the limits of the worked matrix, and propose evidence that could change a decision. The next part turns the operational requirements into concrete performance, recovery, governance, and security questions.

=== VII · Performance and operations | Performance: measure the workload, not the slogan
> **Learning goals for this part:** Design a fair workload experiment; separate replication, recovery, and scale; preserve meaning, lineage, and permissions through updates and derived views.

An architecture choice needs operational evidence, not just an attractive model. We now return to the recommendation query and ask what makes it expensive: the starting set, the number of relationships expanded, and the amount of output or reasoning required.

### Cost follows the shape of the question
**Selectivity** is how strongly a predicate narrows candidates. **Cardinality** is the number of rows or matches at a stage. **Fan-out** is the number of outgoing or incoming connections considered during expansion. **Skew** means some entities have far more connections than typical ones. These often matter more than the visual simplicity of a query.

The figure follows three contributors to query cost: find starting entities, expand relationships, and produce results. For Maya's question, that means finding her record, examining relevant courses and prerequisites, and returning a small set of eligible courses.

@diagram performance

### RDF execution considerations
A store may use multiple triple or quad index orders, statistics, join planning, and specialized path processing. Selective patterns reduce intermediate results. Named-graph filters, optional patterns, broad joins, reasoning closure, and remote SERVICE calls can affect cost. A formal ontology is not itself a performance problem; the executed reasoning tasks and data distribution determine the work.

### LPG execution considerations
A selective indexed anchor can reduce the starting set before traversal. Dense hubs, repeated expansions, wide results, and Cartesian combinations can dominate cost. A **Cartesian product** combines every row of one independent set with every row of another. Sometimes intended, it is often a sign that a connecting condition is missing.

Use `EXPLAIN` to inspect the planned query and `PROFILE` to execute with runtime information in Neo4j. PROFILE runs the query, including writes if the query contains them; use read-only examples or a safe exercise database. Compare estimated and actual row counts and inspect index access versus scans. [27]

### What cannot be concluded
No benchmark is provided here. “RDF uses joins” does not prove it is slower. “A graph follows pointers” does not prove a traversal is cheap. Both implementations and workload shape matter. Compare actual engines, configurations, query semantics, datasets, and resource budgets.

=== VII · Performance and operations | Design a fair benchmark
The previous section identified possible sources of cost. We now design an experiment to measure them fairly. The catalog remains our conceptual example, but a meaningful benchmark must enlarge it and include realistic distributions, concurrent activity, and independently checked answers.

### Build a workload with expected answers
A **benchmark** is a repeatable measurement under declared conditions. Include lookup, bounded prerequisite traversal, recommendation filtering, event ingestion, evidence retrieval, and export. Verify answers first: a fast query that omits an eligibility condition is not a successful optimization.

Before reading the checklist, separate three measurements. **Latency** is time per request; **throughput** is completed work per unit time; a **latency percentile** summarizes a distribution of request times. We interpret p50 and p95 below. Hardware measurements include **CPU** use (central processing unit activity), memory use, and **I/O** (input/output work such as storage reads and writes).

| Dimension | What to record |
|---|---|
| Dataset | Entity counts, edge counts, degree distribution, literal sizes, topic overlap, provenance volume |
| Semantics | Explicit versus inferred facts, duplicate handling, named graphs, path bounds, completeness policy |
| Environment | Engine version, edition, configuration, CPU, memory, storage, network |
| Load | Query mix, concurrent clients, update frequency, read/write ratio |
| Metrics | Latency percentiles, throughput, errors, CPU, memory, I/O, ingest lag |
| Reproducibility | Generator seed, scripts, query text, snapshots, warm-up, repetitions |

### Interpret the measurements
For the latency measurements just introduced, **p50** is the median; **p95** is a value at or below which 95% of observations fall. Tail latency matters when users wait for the slow requests. Report timeouts and failures separately rather than excluding them from the measurements.

A **cold-cache** run starts without relevant data already cached; a **warm-cache** run benefits from prior access. Distinguish both. Repeatedly executing one tiny query on a fully cached toy graph tells little about a mixed production workload.

### Optimize transparently
Record each added index, projection, materialized inference, and precomputed feature. Include the cost to maintain them during updates. Run correctness checks after every optimization. Increase graph size and concurrency independently to identify bottlenecks. Include high-degree topics and long prerequisite chains rather than only uniform synthetic data.

A useful experiment can reject both candidates: if the question is mostly large text aggregation over documents, a graph may be an auxiliary structure rather than the primary processing engine. Let the workload determine the architecture.

=== VII · Performance and operations | Scale, transactions, backup, and recovery
A benchmark measures normal execution. Operating the catalog also means handling growth, concurrent changes, and failure. This section separates those concerns so that “a graph cluster” is not mistaken for an answer to every availability or recovery problem.

### Distinguish scale strategies
**Vertical scaling** adds resources to one machine. **Horizontal scaling** adds machines. **Replication** maintains copies for availability or read service. **Partitioning**, or sharding, distributes data across partitions. These are different mechanisms. A cluster does not automatically make every query parallel or remove cross-partition costs.

Relationship-heavy queries can cross partition boundaries. A design partitioned by learner may still traverse to shared courses and popular topics. RDF federation has similar remote-dependency issues in a different form. Assess locality and high-degree shared entities before selecting a distribution strategy.

### Transactions are an engine concern
RDF and LPG are data models, not isolation levels. Check the actual database documentation for atomicity, locks, isolation, retries, deadlock behavior, and read consistency. Neo4j transactions provide database-defined guarantees; application code must still handle retryable failures and preserve idempotency. [28]

A **deadlock** is a cycle of transactions waiting on resources held by one another. A **retry** reattempts a failed operation. Stable event identifiers and deterministic writes reduce duplication risk. Do not place external side effects, such as sending a notification, inside code that may be retried without a separate delivery design.

### Backup is only useful if restoration works
A **backup** is a recoverable copy. A **restore test** demonstrates that the copy can recreate a usable system. **Recovery point objective**, RPO, is the tolerated amount of lost data measured in time. **Recovery time objective**, RTO, is the tolerated time to restore service. Replication alone is not a backup against accidental deletion propagated to replicas.

Test restoration of data, indexes, constraints, ontology versions, shapes, mappings, permissions, and evidence references. Then execute competency queries. If a projection is rebuildable, measure its rebuild time against the service requirement. Keep a procedure for partially failed imports and for rolling back a bad ontology or mapping release.

> Plan for the graph, its configuration, and its provenance to recover together. Restoring only nodes and edges can leave the application unable to reproduce prior decisions.

=== VII · Performance and operations | Governance, lineage, and schema ownership
Even a fast and recoverable graph can produce confusing answers if nobody owns the meaning of its terms or the history of its changes. We now identify the people and versioned artifacts needed to explain a catalog decision months after it was made.

### Assign responsibilities to artifacts
**Data governance** defines who may create, interpret, change, publish, and retire data. A **steward** maintains meaning and quality for a domain. A **data owner** is accountable for the authoritative data. **Lineage** traces how an output was produced from inputs and transformations. These responsibilities apply to both graph approaches.

| Artifact | Typical owner | Review evidence |
|---|---|---|
| Entity identity policy | Domain steward | Merge rules, ambiguous examples, reversals |
| Ontology / vocabulary | Semantic model maintainer | Definitions, competency questions, entailment changes |
| SHACL / validation rules | Quality owner | Positive and negative examples, severity policy |
| Application graph schema | Application team | Queries, constraints, migration plan |
| Mapping / projection | Integration owner | Round-trip tests, deletions, reconciliation |
| Evidence / source catalog | Content owner | Source versions, retention, rights, review status |

### Version the dependencies of a decision
A recommendation record should identify the learner and course, input snapshot or watermark, policy version, model version if ranking is learned, ontology and shapes versions where relevant, and evidence used. Without this context, a later query against changed data may give a different answer with no explanation.

**Data quality dimensions** include accuracy, completeness, consistency, timeliness, and uniqueness. They are distinct: a complete file can contain false information, and a unique record can refer to the wrong real-world course. Define metrics that reflect the decision risk rather than reporting only ingestion success.

DCAT, the Data Catalog Vocabulary, can describe datasets and their distributions. A **distribution** is an accessible representation of a dataset, such as a downloadable RDF file or a response supplied through an **application programming interface (API)**, a defined way for software to request and exchange data. Catalog metadata helps discovery and governance but does not certify the truth of every statement. [29]

### Deprecate with a migration path
When replacing a term or changing prerequisite semantics, publish a replacement, explain changed meaning, set a transition window, and identify dependent queries. Keep historical versions available when needed to reproduce prior outcomes.

=== VII · Performance and operations | Security and privacy across graph boundaries
The catalog contains learner-specific completions, so correct answers also need correct permissions. We now follow a learner fact through queries, exports, derived views, and generated explanations to show where access or deletion rules must continue to apply.

### Graph structure can reveal sensitive information
Access to a node can expose information through its neighbors. A course-completion path may reveal a learner's identity, training status, or protected workplace role even if a direct profile field is hidden. **Authorization** decides what a user may access. **Authentication** establishes who the user is. Neither follows automatically from a named graph or a node label.

A **tenant** is an isolated customer or organizational scope. A **least-privilege** policy grants only the permissions required for an action. Apply tenant and permission checks at all entry points, including search, graph expansion, exports, caches, analytics, and generated answers. A filtered user interface is not a substitute for enforced access controls.

### Treat query generation as an untrusted input path
Parameterize values. Limit accepted query structures when using generated queries. Use read-only credentials for question answering. Bound execution time and result size. Restrict remote SPARQL SERVICE endpoints. Avoid exposing unrestricted database procedures through a natural-language interface.

**Query injection** manipulates query syntax through untrusted input. **Prompt injection** supplies text intended to redirect a language model's behavior. A source document used as evidence should be treated as content, even if it contains imperative sentences. It must not be allowed to change access policy, select unrestricted tools, or override the application's instructions.

### Deletion and derived data
A privacy deletion may need to propagate to graph nodes, events, claims, document chunks, embeddings, search indexes, caches, and analytics projections. **Retention** defines how long information is kept. **Pseudonymization** replaces direct identifiers while preserving a linkable identity under controlled conditions; it does not necessarily make a graph anonymous.

Audit access and changes with enough information to investigate incidents, while protecting logs themselves. Check licenses and permissions for source documents before distributing a graph or a tutorial dataset derived from them. The example data in this book is synthetic and contains no real learner records.

### Connection to the next part
The catalog now has an operational context as well as a model. Next we add natural-language answering and examine how graph RAG must preserve those same identity, policy, evidence, and permission boundaries.

### Check your understanding
**Try first:** core questions for this chapter are 1, 5, 6, 9, 12, 13, 15, 17, 20. They cover its main concepts and application decision. Attempt the remaining questions as a second pass. Cover the next answer with a sheet or scroll it out of view while writing your prediction. Compare the explanation only after committing an answer.

This chapter tested what a graph system needs beyond a correct small example: realistic measurements, recovery, accountable ownership, and enforced permissions. The questions follow those responsibilities in order. Treat numerical service targets as requirements to define and measure, not results already established by this tutorial. Explain which evidence would support each operational claim.

### Review 1 · Explain the work a query performs
**Question 1: Why can a query with a short graph pattern still be expensive?**

**Answer:** Its starting set can be large, a popular topic can have high fan-out, and compatible matches can multiply into many intermediate rows. A small final result does not imply that little work was performed. Selectivity, cardinality, skew, and output width matter alongside query syntax. Inspect the actual workload and plan rather than estimating cost from how compact the query looks.

**Question 2: How does a selective indexed anchor help, and what can remain expensive afterward?**

**Answer:** It can narrow the starting set efficiently, for example by finding one learner through a stable id. Subsequent expansions can still encounter dense hubs, long prerequisite chains, optional matches, or large evidence sets. An index addresses selected lookups; it does not guarantee that all later graph work is cheap. Test both the entry point and the downstream operations.

**Question 3: What is a Cartesian product, and why might DISTINCT conceal rather than solve its cause?**

**Answer:** It combines every row from one independent set with every row from another. If patterns intended to refer to the same course use unrelated variables, they can create many unintended combinations. DISTINCT can remove identical projected outputs while leaving the unnecessary work and incorrect associations in place. Check the joining conditions and intended counting unit before treating repeated rows as a presentation problem.

**Question 4: How do EXPLAIN and PROFILE differ, and why should PROFILE be used carefully?**

**Answer:** EXPLAIN shows a planned execution without running the query. PROFILE executes it and supplies runtime information, such as observed row counts. A profiled write query still writes; profiling is not a read-only simulation. Use appropriate exercise data and permissions, and compare estimated and actual behavior. A plan for one data distribution is not proof of performance under every load.

### Review 2 · Make benchmark claims reproducible
**Question 5: What must be equal or explicitly accounted for when comparing an RDF stack with an LPG stack?**

**Answer:** Match the conceptual facts, required answers, eligibility policy, and declared workload. Record resource budgets, engine versions, reasoning, path bounds, duplicate handling, and precomputed views. Equivalent results can involve different representations and plans, so identical syntax or raw storage counts are not required. A candidate that omits a condition or serves older data is not answering the same question merely because it responds faster.

**Question 6: How do latency, throughput, p50, and p95 describe different aspects of service?**

**Answer:** Latency measures time per request; throughput measures completed work per unit time. p50 is the median observed latency, while p95 describes a tail threshold at or below which 95% of observations fall. A system can have an acceptable median and slow tail requests. Report the load, measurement method, errors, and timeouts alongside percentiles rather than quietly excluding failed requests.

**Question 7: Why separate cold-cache and warm-cache runs and include skewed data?**

**Answer:** Cached data can make repeated requests much cheaper than first access. Popular topics and high-degree nodes can create costs absent from a uniform toy graph. Distinguish cache conditions and include representative degree distributions, topic overlap, and long chains. Otherwise, the experiment may measure an unusually favorable case rather than the conditions users will encounter.

**Question 8: Why rerun correctness checks and include maintenance cost after an optimization?**

**Answer:** A projection, materialized inference, or precomputed feature can improve reads while changing freshness, update cost, or even answers if maintained incorrectly. Verify expected outputs after the change and measure the work needed to keep the optimization current. A faster query is not a successful improvement if it silently loses prerequisites or cannot meet the required update rate.

### Review 3 · Separate scale, availability, and recovery
**Question 9: How do vertical scaling, horizontal scaling, replication, and partitioning differ?**

**Answer:** Vertical scaling adds resources to a machine; horizontal scaling adds machines. Replication maintains copies, often for availability or read service. Partitioning distributes data across partitions. A cluster can combine these mechanisms, but adding machines does not automatically parallelize every query or remove cross-partition costs. Identify the bottleneck and the actual deployment behavior before selecting a scale strategy.

**Question 10: Why might partitioning the catalog by learner still require remote work?**

**Answer:** Learners connect to shared courses, topics, and prerequisites that may lie outside their partition. A recommendation can therefore cross partition boundaries repeatedly, especially around popular shared entities. Assess graph locality, network work, and consistency needs for the actual query patterns. Separating records by one entity type does not ensure that the relationships used together remain local.

**Question 11: How do deadlocks and retries affect a completion-ingestion operation?**

**Answer:** Concurrent transactions can wait on one another's resources in a cycle, leading the database to abort an operation that may need retrying. The application must handle the actual engine's retry behavior and preserve the intended event identity. A retry must not fabricate another completion. External actions such as notifications need a separate delivery design if the transactional code can run more than once.

**Question 12: Why is a replica insufficient as the only recovery measure?**

**Answer:** Accidental deletion, an incorrect import, or another harmful committed change can propagate to replicas. Copies that contain the same damage do not supply an earlier valid state. Recovery requires suitable recoverable copies and a tested restoration procedure. Availability during a machine failure and recovery from a bad data change are different requirements, even when one architecture addresses both.

**Question 13: What is the difference between RPO and RTO, and what must a restore test include?**

**Answer:** The recovery point objective is the tolerated data loss measured in time; the recovery time objective is the tolerated time to restore service. Test recovery of data together with relevant indexes, constraints, ontologies, shapes, mappings, permissions, and evidence references. Then run competency queries and measure projection rebuilds where needed. A backup file's existence alone does not demonstrate either objective or a usable recovered application.

### Review 4 · Preserve meaning and decision history
**Question 14: Why assign owners to identity rules, ontologies, shapes, mappings, and evidence separately?**

**Answer:** Those artifacts govern different decisions and can fail in different ways. A domain steward can review entity meaning while an integration owner maintains mappings and a quality owner manages acceptance rules. Make accountability and review evidence explicit even if one person holds several roles. An unowned transformation or vocabulary can change application behavior without anyone evaluating the consequences.

**Question 15: What must be recorded to explain a recommendation after the catalog changes?**

**Answer:** Retain the relevant learner and course identifiers, input snapshot or watermark, policy version, evidence, and applicable ontology, shape, and ranking-model versions. A later query against today's data may produce a different answer for legitimate reasons. Lineage connects the historical output to the inputs and transformations that produced it; the course id alone cannot reproduce that context.

**Question 16: Can a complete, unique dataset still be inaccurate? Does catalog metadata certify its contents?**

**Answer:** Yes, and no. Every required field can be present and every identifier unique while a duration is false or a record identifies the wrong course. Accuracy, completeness, consistency, timeliness, and uniqueness are distinct quality dimensions. Metadata such as DCAT descriptions helps people discover and interpret datasets and distributions; it does not establish that every assertion is true. Choose checks according to the decision risk.

### Review 5 · Enforce boundaries through derived data
**Question 17: How do authentication and authorization differ, and why is a hidden interface field insufficient protection?**

**Answer:** Authentication establishes who the user is; authorization determines what that user may access or do. Hiding a field in the interface does not stop another query, export, neighbor expansion, or generated answer from exposing the information. Enforce tenant and permission boundaries at the relevant service and data access points, using least privilege. Node labels and graph names do not establish those controls by themselves.

**Question 18: How do query injection and prompt injection differ, and what should question-answering access permit?**

**Answer:** Query injection manipulates query syntax through untrusted input; prompt injection attempts to redirect a model through supplied text. Parameterize values, restrict generated query structures, and use appropriately limited read-only access for answering. Treat source passages as evidence content, even when they contain commands. They must not gain authority to change access policies, invoke unrestricted tools, or select arbitrary remote SERVICE destinations.

**Question 19: Why can deleting a learner node leave sensitive information elsewhere?**

**Answer:** Related events, claims, source chunks, embeddings, indexes, caches, projections, and logs may still contain or reveal the learner's information. Define the applicable retention and deletion policy across those derived representations and verify propagation. Pseudonymization can preserve linkable identities and does not necessarily make graph structure anonymous. Protect audit logs as well as the primary graph.

### Apply the chapter to a failure
**Question 20: A faulty mapping release publishes incorrect prerequisites, the mistake reaches replicas and a retrieval cache, and a recent backup exists. What must recovery establish?**

**Answer:** Identify the affected versions and decisions, stop or contain further faulty publication, and recover a valid authoritative state using the appropriate procedure. Restore or roll back compatible mappings and related rules, then rebuild or invalidate affected projections and caches. Reconcile the recovered relationships and run expected eligibility queries before treating the service as repaired. Measure data loss and restoration time against the RPO and RTO. The replica count and presence of a backup do not, by themselves, establish a correct recovery.

**Ready to continue:** You should be able to design a meaningful performance comparison, distinguish replication from recovery, identify the dependencies needed to reproduce decisions, and follow permission and deletion requirements into derived views. The graph RAG chapter applies those same boundaries to retrieval, generation, and learned signals.

=== VIII · Graph RAG and analytics | What graph RAG adds to retrieval
> **Learning goals for this part:** Explain where a graph helps retrieval; separate reviewed facts from extracted claims; evaluate evidence and permission failures; distinguish prediction from eligibility.

We now add a new user interface to the catalog: a person asks a question in ordinary language and expects an evidence-backed answer. This section introduces retrieval-augmented generation, then explains where the graph can contribute to answering “What can Maya study next, and why?”

### Start with the new user need
Until now, a fixed query has returned course records. Imagine instead that a user asks in everyday language, “Why is Graph Search a suitable next course for Maya?” The system must find both the structured eligibility facts and readable source passages, then compose an explanation supported by that evidence. This motivates the retrieval-and-generation approach introduced below.

### Start with ordinary RAG
**Retrieval-augmented generation**, or RAG, supplies retrieved evidence to a language model before it generates an answer. A **large language model**, LLM, predicts and generates text; it is not an authoritative database. A **chunk** is a selected span of source content. An **embedding** represents content as a numeric vector so that a similarity function can compare representations.

**Vector retrieval** finds items with nearby embeddings. It can retrieve a course description that sounds relevant while missing a crucial prerequisite. **Graph RAG** uses graph structure during evidence organization, retrieval, expansion, or summarization. It is a family of designs, not one standardized algorithm and not a capability reserved for one graph model.

Read the figure from the question to the structured policy query, then retrieve candidate text, expand relevant graph connections, filter and rank evidence, generate an answer, and verify it. Each box is a pipeline responsibility; neither RDF nor Neo4j supplies the complete pipeline merely by storing a graph.

@diagram rag

### A question that benefits from structure
“Which graph course can Maya take next, and why?” requires identity resolution, topic preferences, completions, prerequisites, and current course descriptions. A document-only answer may overlook a missing prerequisite. A graph-only answer may lack explanatory text from the source. A combined pipeline can use structured eligibility and retrieve supporting passages for the explanation.

A **retriever** selects candidate evidence. A **reranker** reorders candidates using a more focused scoring method. **Grounding** ties generated statements to supplied evidence. A **citation** identifies the source supporting a statement. A source link alone does not demonstrate that the cited passage actually supports the claim.

### Local and global questions
Local retrieval starts from entities and explores a relevant neighborhood. Global questions may require summaries across communities or large portions of a corpus. Here a community is a group of densely connected entities under a chosen graph view; a community summary condenses source material associated with that group. It is still derived text to evaluate, not an authoritative catalog rule. A published graph RAG approach uses graph-derived community summaries for query-focused summarization; that is a specific design within the wider family. [30]

=== VIII · Graph RAG and analytics | Build evidence before generating answers
The previous section described the answering flow. Before that flow can work, source documents must become reliable, permission-aware evidence. We now extend the catalog with document records and extracted candidate claims, keeping them distinct from reviewed prerequisites and completions.

### A governed indexing pipeline
1. Register each source document with a stable ID, version, access policy, and publication time.
2. Split content into chunks while preserving document IDs and span locators.
3. Extract candidate entities and claims with evidence spans; mark extracted content as unreviewed when appropriate.
4. Resolve entities against canonical IDs and validate claims against the domain contract.
5. Store structured relationships, evidence links, and searchable text or embeddings.
6. Publish a versioned retrieval view after quality and access checks.

### Extraction is not assertion of truth
**Information extraction** converts text into structured candidates. **Entity linking** connects a mention in text to a known entity. **Relation extraction** proposes relationships between entities. A model might confuse a course that discusses prerequisites with a course that requires another course. Retain the source sentence and allow review rather than silently treating every extracted edge as authoritative.

Use a **claim node** when a statement can be disputed, time-bound, or supported by multiple documents. A claim can have a status such as candidate, reviewed, rejected, or superseded. Keep conflicting claims if provenance is important, while defining which statuses the decision engine is allowed to use.

### Choose a source of truth for eligibility
The catalog's reviewed prerequisite field should control eligibility, not whichever wording ranks highest in vector search. Retrieval can help find explanations and discover candidate facts, but it must not bypass the policy. In RDF, use explicit graph scopes for reviewed assertions. In an LPG, use governed relationship sets or claim-status filters. In either case, graph access must respect the user's permissions.

A **knowledge-graph construction pipeline** is a series of parsing, extraction, linking, validation, and publication steps. A toolkit can automate parts of this pipeline, but its defaults do not replace domain decisions about identity, evidence, or confidence. Implementation documentation should be checked for exact supported database versions and retriever behavior. [31]

> Store the evidence span with the claim. An attractive graph without traceable evidence is a difficult system to debug.

=== VIII · Graph RAG and analytics | A retrieval plan for the running example
Assume the evidence pipeline has published reviewed, authorized catalog data and source passages. We can now trace one answer from Maya's question to candidate courses and supporting evidence. The block below is architecture pseudocode, not Cypher, SPARQL, or runnable Python.

### Keep structured policy and explanatory text coordinated
The following is architecture pseudocode. It is intentionally independent of database drivers and vector-index APIs, whose syntax and filtering support vary by release.

**Architecture pseudocode — one answering request.** Read each line as a responsibility to implement. Named functions are explanatory placeholders, and the hop and token limits are illustrative settings.

```text
answer(question, user_context):
    identity = resolve_authorized_subject(question, user_context)
    scope = authorized_catalog_snapshot(user_context)
    candidates = query_eligible_courses(identity, scope)
    seeds = retrieve_text(question, scope, limit=20)
    evidence = expand_from_candidates(
        candidates, seeds, allowed_relations, max_hops=2)
    evidence = filter_permissions_and_freshness(evidence)
    evidence = rank_and_limit(evidence, token_budget=4000)
    if missing_required_evidence(evidence):
        return abstain_with_reason()
    draft = generate_from_evidence(question, candidates, evidence)
    return verify_support_and_citations(draft, evidence)
```

A **token budget** limits the amount of model input or output. A **seed entity** is a starting point for graph expansion. An **allowlist** names permitted relation types or tools. A **freshness policy** defines which versions or timestamps are acceptable. **Abstention** is an explicit choice not to answer when required evidence is missing.

### Trace one answer
For this walk-through, assume that evidence document d2 has now been registered and contains a reviewed description of c2, while d1 supports completion event e1. These document records belong to the evidence extension, not the original baseline. The eligibility query returns c2. Expansion gathers its Graphs topic, its c1 prerequisite, Maya's qualifying completion event, and d2's course description. The generator receives only authorized evidence. It explains the recommendation and cites the passage supporting the course description and the record supporting completion, with appropriate user-facing locators.

### Why a bounded neighborhood matters
Expanding every reachable edge can mix irrelevant topics, leak information, and exhaust the context window. A two-hop bound is illustrative, not a universal optimum. Measure whether it retrieves the required evidence for each question class. A global summary question may need a different retrieval route rather than a larger local radius.

Do not make text-to-query generation the only route for a known policy. A fixed, parameterized eligibility query is easier to validate than arbitrary generated logic. If generated queries are allowed, inspect and restrict their structure before execution.

=== VIII · Graph RAG and analytics | Evaluate graph RAG by failure mode
The retrieval plan explains the intended behavior. We now test whether the system actually retrieves the right evidence, respects permissions, and supports what it says. The evaluation compares system variants; it does not assume that adding a graph improves every question.

### Separate retrieval, reasoning, and writing quality
An answer may sound fluent while using the wrong learner, omitting a prerequisite, or citing an unrelated passage. Evaluate each stage separately. Compare at least a text-only retrieval baseline, a structured-query baseline where applicable, and a hybrid graph pipeline using the same question set and access policy.

The table separates the questions to test. In “recall at k,” **k** is the number of retrieved items inspected; for example, recall at 10 checks whether the required evidence appears among the first ten items. Precision asks how much of what was retrieved is useful.

| Metric / check | What it reveals |
|---|---|
| Entity-link accuracy | Whether mentions resolve to the right canonical resources |
| Evidence recall at k | Whether required evidence is present among the first k items |
| Evidence precision | How much retrieved material is relevant and usable |
| Eligibility accuracy | Whether structured policy outcomes match reviewed answers |
| Citation support | Whether cited passages support each generated claim |
| Abstention quality | Whether the system declines when evidence is insufficient |
| Permission isolation | Whether any hidden content or derived fact is exposed |
| Cost and latency | Whether the pipeline meets practical service limits |

### Build adversarial examples
Include similarly named courses, missing completion evidence, conflicting prerequisite descriptions, retired editions, stale documents, unauthorized learner records, and text containing malicious instructions. Include questions with no supported answer. A benchmark with only answerable questions encourages overconfident generation.

**Ablation** removes one component to measure its contribution. Remove graph expansion while keeping retrieval and model settings fixed. Remove reranking. Compare reviewed assertions with unrestricted extracted claims. If graph expansion adds cost without improving the relevant outcomes, simplify the pipeline.

### Distinguish similarity from support
Embedding similarity indicates a relationship in a representation space, not factual entailment. A high similarity score is not a calibrated probability that a claim is true. Graph adjacency also does not prove support: ABOUT and REQUIRES carry different meanings. Preserve relation semantics during retrieval and explanation.

A graph can reduce some retrieval failures by exposing structure, but it does not eliminate hallucination or guarantee causal reasoning. Quality depends on extraction, identity, evidence, policies, retrieval, and generation together. Use this evaluation plan as a system design proposal, not as an empirical claim that one graph approach always produces better answers.

=== VIII · Graph RAG and analytics | Graph algorithms and learned representations
Graph RAG uses relationships to find evidence, but a graph can also support analytics and learned recommendation scores. We now distinguish those tools from the rule-based eligibility query. A predicted interest can help rank c2; it cannot silently redefine whether Maya completed c1.

### Different tools answer different questions
A **graph algorithm** computes a structural property or solution over a graph. A **graph embedding** assigns vectors to nodes or graphs using structure, attributes, or both. A **graph neural network**, GNN, learns representations by combining information from connected entities according to a model architecture. These are distinct from OWL reasoning and from ordinary graph queries.

| Technique | Typical question | Limitation to remember |
|---|---|---|
| Connected components | Which nodes are connected in a selected relation view? | Connectivity does not imply similarity or identity |
| Centrality | Which nodes are structurally prominent? | Popularity can reflect bias or data collection |
| Community detection | Which groups are densely connected? | Communities depend on algorithm and graph projection |
| Similarity / embeddings | Which courses or learners look alike? | Similarity is not eligibility or semantic equivalence |
| Link prediction | Which relationship may occur next? | Prediction is not a verified fact |
| Shortest path | What route minimizes hops or cost? | A short path need not be a valid learning plan |

A **graph projection** for analytics selects labels, relationships, directions, and weights from operational data. A graph data science engine can run algorithms on that projection. Exact algorithms, memory requirements, and execution features depend on the selected engine. [32]

### Use predictions after hard rules
A recommender can predict interest in c3 and still exclude it if prerequisites are unmet. A ranking model should not redefine “completed.” Keep learned scores separate from reviewed facts. Track model versions and evaluation data so that a recommendation is reproducible.

**Data leakage** occurs when information unavailable at prediction time enters training or evaluation. For temporal recommendations, split by time and prevent future completions from influencing past predictions. **Cold start** describes limited evidence for a new user or item. Topics and ontology structure can provide useful features, but their usefulness must be evaluated rather than assumed.

### Connection to the next part
These techniques broaden what the graph can do, but their outputs still depend on the definitions and evidence introduced earlier. The next part revisits the ideas through mistakes, controlled exercises, and contrasting project scenarios.

### Check your understanding
**Try first:** core questions for this chapter are 1, 2, 6, 8, 10, 11, 13, 16, 22, 23. They cover its main concepts and application decision. Attempt the remaining questions as a second pass. Cover the next answer with a sheet or scroll it out of view while writing your prediction. Compare the explanation only after committing an answer.

This chapter added retrieval, generation, and analytics to the catalog; it did not replace the reviewed eligibility policy. The questions follow an answer from source indexing through retrieval and verification, then distinguish learned recommendations from verified facts. Document records such as d1 and d2 belong to the evidence extension, not the original baseline. Predict what the system should do before reading each answer.

### Review 1 · Identify the job of each component
**Question 1: What does ordinary RAG add to a language model, and what makes a design graph RAG?**

**Answer:** Ordinary retrieval-augmented generation supplies retrieved material as context before a model generates an answer. Graph RAG uses graph structure in organizing, retrieving, expanding, or summarizing that evidence. It is a family of designs rather than one standard algorithm. Neither RDF nor an LPG supplies a complete answering pipeline simply by storing connections; retrieval, access checks, generation, and verification still need implementation.

**Question 2: Why can a relevant course description be insufficient to answer “What can Maya study next?”**

**Answer:** The description may discuss Graphs without establishing whether Maya has completed the course or satisfied its prerequisites. Eligibility requires the structured policy and relevant reviewed records. Retrieved prose can explain the course, while completions and prerequisites establish the policy result. A fluent answer based only on a top-ranked description can miss a decisive unmet requirement.

**Question 3: How do a retriever, a reranker, grounding, and a citation differ?**

**Answer:** A retriever selects candidate material; a reranker changes the order of those candidates using another scoring method. Grounding ties generated claims to supplied evidence. A citation identifies a supporting source or location. A reranker score is not itself evidence, and a citation is useful only if its referenced content actually supports the claim. Evaluate those responsibilities separately rather than treating one source link as proof of the whole answer.

**Question 4: Should a global question about the catalog always use a larger local neighborhood?**

**Answer:** No. Local retrieval starts from selected entities and nearby connections. A global question can require coverage or summaries across many communities or a larger corpus. Increasing a local hop radius can add noise and cost without supplying representative coverage. Choose and evaluate the retrieval route for the question class; the example's two-hop setting is an illustration, not a universal optimum.

### Review 2 · Prepare trustworthy, authorized evidence
**Question 5: What must remain attached to a chunk when a source document is split?**

**Answer:** Retain its document identity, version, location within the source, and applicable access information. Those links let the system trace a retrieved passage back to the exact source and apply the relevant permissions and freshness policy. Detached text may sound useful while being impossible to verify or unsafe to disclose. Chunking is a preparation step, not permission to discard source context.

**Question 6: Why is extracting a relation different from accepting it as a reviewed fact?**

**Answer:** Extraction proposes a structured interpretation of text. It can confuse a course that discusses prerequisites with a course that requires another course. Preserve the supporting span, resolve the entity identities, validate the proposed relation, and apply the declared review process. A syntactically valid edge can still have the wrong meaning. Candidate claims should not silently enter the relationship set used for eligibility.

**Question 7: Two course editions share a similar title. Why must entity linking be checked before graph expansion?**

**Answer:** Expansion from the wrong edition can retrieve internally connected but irrelevant prerequisites, completions, and descriptions. More hops then amplify the identity mistake rather than correct it. Link the mention to the intended canonical resource using appropriate evidence and context, and handle unresolved ambiguity explicitly. Accurate retrieval depends on starting from the correct entity, not merely a similarly named one.

**Question 8: Does a retrieved or predicted edge automatically qualify as evidence for eligibility?**

**Answer:** No. Check the relationship's meaning, source provenance, review status, freshness, permissions, and permitted policy role. An ABOUT edge is not a REQUIRES edge; a predicted COMPLETED edge is not a verified completion. A source can be relevant without being authoritative for the decision. The application must specify which reviewed facts and evidence are allowed to establish eligibility.

**Question 9: What should happen when a highly ranked passage conflicts with the reviewed prerequisite record?**

**Answer:** Ranking alone should not override the designated source of truth. Preserve the conflicting claim and its evidence for review, and follow the declared authority and conflict policy. If the conflict undermines required evidence, withhold the affected conclusion or qualify it as the policy requires. Do not let a generator silently reconcile incompatible facts by selecting whichever wording sounds more convincing.

**Question 10: Why must permissions apply to graph expansion and generated summaries as well as retrieved documents?**

**Answer:** A hidden completion record or relationship can reveal sensitive information even if the original document is never displayed. Summaries and generated explanations can disclose facts derived from restricted sources. Apply authorization to the subject, graph scope, evidence, and outputs throughout the request. A final document-link filter cannot repair information already exposed to an unauthorized generation context or answer.

### Review 3 · Follow and constrain one answering request
**Question 11: Why compute eligible courses with a known policy query before asking the generator to explain the result?**

**Answer:** It keeps the decision tied to explicit, testable conditions rather than improvised generated logic. The generator can describe the eligible candidates using authorized supporting material without redefining completion or prerequisites. For Maya, the baseline policy returns c2; the evidence extension then supplies the completion support and course description. The chapter's pseudocode names these responsibilities but is not a runnable driver or a completed service.

**Question 12: What does bounding hops and tokens accomplish, and what does it not guarantee?**

**Answer:** Bounds limit graph expansion and the amount of material passed to the model, helping control cost, latency, and irrelevant context. They do not guarantee that the necessary evidence is included or that all included facts are relevant and authorized. Test whether each question class retains its required evidence under the chosen limits. If a bound removes a decisive prerequisite, revise the plan rather than accepting an incomplete explanation.

**Question 13: When should the pipeline abstain, and why is abstention not the same as answering “not eligible”?**

**Answer:** Abstain when evidence required for the requested conclusion is missing, inaccessible, stale, or otherwise insufficient under the policy. “Not eligible” is a policy result supported by the required inputs, such as a known unmet prerequisite. “Insufficient evidence to determine eligibility” describes a limitation in what can be established. Keeping those outcomes separate prevents a retrieval failure from being presented as a negative fact about the learner.

**Question 14: Why does a generated answer with citations still need verification?**

**Answer:** The cited passage may be unrelated, refer to a different edition, or support only part of a sentence. Check the answer's claims against the actual authorized evidence and confirm that the locators identify the intended source versions. For a recommendation, check the structured eligibility result too. A citation's presence establishes that a reference was produced, not that the explanation is accurate or complete.

**Question 15: Why restrict generated queries instead of executing any query a model proposes?**

**Answer:** A proposed query can read unauthorized records, change data, request expensive expansions, or implement the wrong policy. Prefer a validated parameterized query for a known eligibility task. Where generated queries are needed, restrict their structure, operations, and resource use before execution, under the application's access controls. Instructions found inside retrieved text are source content, not authority to change those execution rules.

### Review 4 · Evaluate failures and useful contributions
**Question 16: How can evidence recall, evidence precision, and citation support disagree?**

**Answer:** Recall measures how much required evidence was retrieved; precision measures how much retrieved material is relevant and usable. A result set can include every required item but also contain much irrelevant text. Citation support asks whether the answer's cited content actually supports its claims; a generator can cite the wrong passage even when the right evidence was retrieved. Improving one measure does not automatically fix the others.

**Question 17: Why compare text-only, structured-query, and hybrid baselines on the same questions?**

**Answer:** They show which tasks benefit from graph structure and what additional cost it introduces. A structured query may already answer a precise eligibility question, while prose retrieval supplies descriptive support and a hybrid combines them. Keep the question set and access policy comparable. A graph pipeline should earn its complexity through relevant improvements, not through a comparison against an artificially weak alternative.

**Question 18: What is an ablation, and which difficult cases belong in this evaluation?**

**Answer:** An ablation removes a component, such as expansion or reranking, while holding other relevant settings fixed to examine its contribution. Include ambiguous names, conflicting prerequisites, stale or missing completion evidence, restricted records, malicious source instructions, and questions without a supported answer. Also measure latency and cost. A test set containing only easy, answerable questions cannot reveal whether the pipeline abstains or respects boundaries when it matters.

### Review 5 · Keep analytics separate from authoritative facts
**Question 19: Does embedding similarity, centrality, or community membership establish identity or eligibility?**

**Answer:** No. Embeddings express similarity in a chosen representation; centrality measures a form of structural prominence; community detection groups nodes under an algorithm and graph view. Their outputs can be useful features or retrieval signals without proving identity, prerequisite satisfaction, or truth. A high similarity score is not automatically a calibrated probability that a claim is correct. Preserve the distinction between those signals and reviewed records.

**Question 20: What distinguishes a graph query, OWL reasoning, and a GNN prediction?**

**Answer:** A graph query retrieves or computes results according to its patterns and operations. OWL reasoning derives logical consequences under selected formal semantics. A graph neural network learns representations using connected information according to its architecture and training. These mechanisms answer different questions. A learned likely completion is not the same as a recorded completion or a logically entailed fact, even if all three outputs are represented as edges.

**Question 21: Why record an analytics projection and prevent temporal data leakage?**

**Answer:** The projection selects the nodes, relationship types, directions, and weights available to the algorithm, so it helps define what the result means. Temporal leakage occurs if information unavailable at the prediction time, such as a future completion, enters training features or evaluation inputs. Record data and model versions and split by time appropriately. Apparent accuracy based on future knowledge is not evidence of a deployable recommender.

**Question 22: Can ontology topics solve cold start, and should a high predicted interest override an unmet prerequisite?**

**Answer:** Topics and domain structure can provide features when a new learner or course has little interaction history, but their usefulness requires evaluation. That potential benefit does not make an uncertain preference prediction authoritative. Use reviewed hard rules to determine eligibility, then apply learned scores to rank qualifying candidates under the stated policy. A high predicted interest cannot supply a missing completion record.

### Apply the chapter to an attractive but unsupported answer
**Question 23: The retriever finds an excellent description of c2, a model predicts that Maya completed its new prerequisite, and the only supporting completion document is unauthorized. May the answer recommend c2 as eligible?**

**Answer:** Not on that basis. The description supports course content, not prerequisite completion; the predicted edge is not a verified completion; and restricted evidence cannot be used outside its authorized scope. Evaluate the policy against the permitted reviewed data. If required evidence is insufficient, return the appropriate limited or abstaining result without revealing the restricted record. If authorized policy inputs establish an unmet prerequisite, report that outcome accurately. Fluency and high relevance scores cannot compensate for missing authority or evidence.

**Ready to continue:** You should be able to trace a supported answer, identify where extraction and prediction remain uncertain, explain permission and freshness boundaries, and design checks for the pipeline's actual failure modes. Chapter 9 now applies these distinctions through mistakes, guided exercises, and architecture cases.

=== IX · Applied mastery | Common mistakes and how to repair them
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

=== IX · Applied mastery | Guided exercises with answer explanations
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

=== IX · Applied mastery | Architecture case studies and model answers
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

=== X · Reproducible lab | Files, versions, and execution boundaries
We now move from reading examples to reproducing them. This section identifies the complete lab files and separates checks you can run locally from behaviors that require a configured database or reasoning engine. Begin with a clean baseline before trying any model extension.

### The companion lab
The downloadable lab contains the baseline RDF catalog, SHACL shapes, an OWL example, SPARQL queries, a full Cypher loader and query set, and a small RDF checker. A README lists commands and expected answers. The examples are synthetic and intended for a dedicated exercise environment.

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

The lab includes a Docker-based checker for an empty, dedicated database. Its baseline and named policy cases were executed against Neo4j Community 5.26.30 on 13 November 2026. The validation report records the scope and observed results; the checker does not install a production server. A successful fixture check is not a test of concurrent writes, recovery, or production performance. Newer releases may introduce schema and path features beyond this baseline. [2, 6, 7]

### Keep the experiment honest
Do not combine extension snippets with the baseline and expect unchanged counts. The event, named-graph, provenance, and Graph RAG examples illustrate later modeling choices. Treat each extension as a controlled migration, update the expected answers, and retain the original fixture for comparison.

=== X · Reproducible lab | Expected outputs and extension checklist
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

=== XI · Glossary | Glossary A–D
**ACID:** atomicity, consistency, isolation, and durability; a family of transaction properties. Consistency concerns enforced invariants, not factual truth.

**Aggregation:** combining solution rows into summaries such as counts or averages. Choose the counting unit before interpreting a result.

**Architecture decision record (ADR):** a record of a design's context, alternatives, evidence, decision, consequences, and revisit conditions.

**Assertion / axiom:** an assertion states a fact; an axiom states a formal commitment. Usage can overlap in ontology languages.

**Blank node:** an RDF resource term without a global IRI. A serialized blank-node label is not a durable cross-file business identifier.

**Canonical identifier:** the preferred identity used after reconciling source-specific identifiers. It requires a scope and a merge policy.

**Cardinality:** either the number of matches in a query stage or a constraint on how many related values may exist; distinguish the context.

**Class / instance:** a category and an individual member of that category. A label may represent a class in an LPG by convention.

**Closed-world policy:** treating a declared dataset as complete for a defined decision. It is not automatically the global semantics of a graph database.

**Competency question:** a concrete question a model must answer, used to guide design and validate usefulness.

**Constraint:** a rule checked by a validation or storage mechanism. Name the enforcement point and failure behavior.

**Cypher:** the declarative graph query language used for Neo4j examples. Patterns bind nodes, relationships, paths, and values.

**Data contract:** an agreement covering structure, meaning, units, identity, quality, and ownership. It is broader than a list of fields.

**Dataset / named graph:** in RDF, a dataset contains a default graph and zero or more named graphs. A graph name does not itself establish trust or permission.

**Datatype:** a defined value space and lexical representation, such as integer or dateTime. A datatype-tagged literal differs from a plain string.

**Description logic:** a formal framework for representing and reasoning about classes, relations, and individuals; foundational to OWL DL.

=== XI · Glossary | Glossary E–L
**Embedding:** a numeric vector representing content or an entity for computation such as similarity search. Similarity is not proof of truth.

**Entailment / inference:** entailment is a logical consequence relation; inference is the process of deriving consequences under a chosen regime.

**Entity resolution / entity linking:** resolution decides which records refer to the same thing; linking connects a mention or record to an identified entity.

**Event node:** an identified occurrence modeled as a node, allowing participants, time, evidence, and lifecycle to be represented explicitly.

**Fan-out / degree:** fan-out is the expansion considered at a query step; degree counts a node's incident connections under a specified definition.

**Federation:** querying or coordinating multiple sources. It requires policies for permissions, failures, and inconsistent snapshot times.

**Focus node:** the node being evaluated by a SHACL shape. Targets determine which nodes become focus nodes.

**Formal semantics:** a precise account of what statements mean and which interpretations or consequences they permit.

**Graph RAG:** a family of retrieval-augmented generation designs using graph structure for organizing or retrieving evidence or summaries.

**Graph projection:** a selected or transformed graph view for analytics or application use. Define source authority and rebuild rules.

**Grounding:** connecting generated claims to supplied evidence. It requires checking support, not merely attaching a link.

**Identity / equality:** the claim that references denote the same entity. In OWL, sameAs has stronger consequences than approximate similarity.

**Index:** a lookup structure that can accelerate selected access patterns, with storage and update costs.

**IRI:** Internationalized Resource Identifier; a globally scoped identifier syntax used for RDF resources and vocabulary terms.

**Join:** combining solutions through compatible shared values. Query engines may implement it with different physical strategies.

**Knowledge graph:** a graph representation of entities, relations, and usable meaning or context. The term has multiple definitions.

**Labeled property graph (LPG):** a graph model with labeled nodes, directed typed relationships, and stored properties. Neo4j is one implementation.

**Literal:** an RDF value term with a datatype. A language-tagged string also has a language tag and datatype rdf:langString. It differs from an IRI naming a resource.

=== XI · Glossary | Glossary M–R
**Mapping / round trip:** a mapping translates representations; a round trip exports and reconstructs data. Preservation must be defined for the required distinctions.

**Materialization:** precomputing and storing inferred facts or derived views. Faster reads may incur extra maintenance and storage.

**Monotonicity:** the property that adding premises preserves previous logical consequences. Absence-based application policies need not be monotonic.

**Multiset:** a collection allowing repeated values or solution rows. RDF graphs are sets of triples, while SPARQL results can have duplicates.

**Namespace:** a governed identifier space for terms. Prefixes abbreviate namespace IRIs but are not the identifiers themselves.

**Ontology:** an explicit model of concepts, relations, and commitments about meaning. Ontology engineering is the design process; a reasoner executes formal reasoning tasks.

**Open-world assumption:** the absence of a fact does not imply its negation. A query over a selected dataset can still test whether a pattern is absent.

**OWL:** Web Ontology Language, used to express formal ontology axioms. OWL 2 EL, QL, and RL are restricted profiles with different computational aims.

**Path / hop:** a path connects graph elements through steps; a hop is one relationship step. Endpoints, routes, and walks are different query outputs.

**Predicate / property:** in RDF, a predicate IRI names a relation or attribute. In LPG usage, a property is usually a stored key–value attribute.

**Provenance / lineage:** provenance records origin and responsibility; lineage traces transformations from inputs to outputs.

**Query rewriting:** transforming a query using schema or ontology knowledge so additional implied answers can be computed without fully materializing closure.

**RAG:** retrieval-augmented generation; supplying selected evidence to a language model during answer generation.

**RDF / RDFS:** Resource Description Framework is a statement-based data model; RDF Schema supplies basic vocabulary and entailment constructs.

**Reasoner:** software that computes semantic consequences, classifications, satisfiability, or consistency under a supported logic.

**Reification:** representing a statement or relation as a describable resource. RDF 1.1 statement reification does not itself assert the described triple.

=== XI · Glossary | Glossary S–Z and notation
**Schema:** a conceptual model, an acceptance contract, or implementation structures such as indexes; specify which sense is intended.

**Selectivity / skew:** selectivity measures narrowing of candidate matches; skew describes uneven data distributions such as highly connected hubs.

**Serialization:** a textual representation of a model. Turtle, N-Triples, TriG, and JSON-LD express RDF in different forms.

**SHACL:** Shapes Constraint Language; evaluates a supplied RDF data graph against shapes. It does not inherently define write-time database enforcement.

**Shape / target / path:** a shape declares checks; a target selects focus nodes; a path identifies the values a property shape examines.

**SKOS:** Simple Knowledge Organization System; supports concepts, labels, and knowledge-organization relations. A broader concept relation is not automatically class subsumption.

**SPARQL:** the RDF query language and related protocol/update family. SELECT returns bindings, ASK returns a boolean, and CONSTRUCT returns a graph.

**Subclass / subproperty:** semantic containment between classes or properties. Subclass membership and subproperty relationships can support entailments.

**Transaction / isolation:** a transaction groups work; isolation specifies how concurrent transactions may interact. Check the selected engine's guarantees.

**Triple / quad:** a triple is an RDF subject–predicate–object statement; a quad adds graph context in common dataset storage terminology.

**Unique-name assumption:** the assumption that distinct names identify distinct entities. OWL does not generally make this assumption for all individual IRIs.

**Validation / consistency:** validation checks a supplied dataset against acceptance conditions; logical consistency asks whether axioms can be satisfied together.

**Vector retrieval:** selecting content by a similarity function over vectors. It complements but does not replace structured eligibility checks.

### Notation quick reference
`ex:` abbreviates `https://example.org/`. `a` is Turtle shorthand for `rdf:type`. `?x` is a SPARQL variable. `(n:Course)` is a Cypher node pattern with a label. `[:REQUIRES]` is a relationship-type pattern. `$value` is a Cypher parameter. `*` and `+` have context-specific path meanings; read the surrounding language and bounds before interpreting them.

=== XII · References | References: semantic foundations
Core references were checked on 10 November 2026; the RDF implementation references [33, 34, 35] were checked on 13 November 2026. Examples and illustrations are original. Citations identify the relevant specifications; they do not imply that every implementation supports every feature. Versioned baselines are deliberate, rather than a claim that older syntax is the newest available.

[1] **RDF 1.1 Concepts and Abstract Syntax.** W3C Recommendation, 2014. Defines RDF terms, triples, graphs, and datasets.
https://www.w3.org/TR/rdf11-concepts/

[2] **RDF 1.1 Primer.** W3C Working Group Note, 2014. An accessible entry point to RDF and linked-data examples.
https://www.w3.org/TR/rdf11-primer/

[3] **OWL 2 Web Ontology Language Primer, Second Edition.** W3C Recommendation, 2012. Introductory ontology modeling and OWL concepts.
https://www.w3.org/TR/owl2-primer/

[4] **SPARQL 1.1 Query Language.** W3C Recommendation, 2013. Pattern matching, query forms, expressions, paths, and aggregates.
https://www.w3.org/TR/sparql11-query/

[5] **Shapes Constraint Language (SHACL).** W3C Recommendation, 2017. Shapes, targets, constraints, and validation reports.
https://www.w3.org/TR/shacl/

[6] **Cypher Manual: Overview, version 5.** Neo4j documentation. Entry point for the versioned query-language baseline.
https://neo4j.com/docs/cypher-manual/5/introduction/cypher-overview/

[7] **Cypher Manual: Constraints, version 5.** Neo4j documentation. Constraint categories and release/edition conditions.
https://neo4j.com/docs/cypher-manual/5/constraints/

[8] **RDF 1.2 Concepts and Abstract Data Model.** W3C Candidate Recommendation Snapshot, 7 April 2026, as displayed when checked. Includes triple terms; check current status and implementation support before use.
https://www.w3.org/TR/2026/CR-rdf12-concepts-20260407/

[9] **RDF 1.1 Turtle.** W3C Recommendation, 2014. Concrete syntax used by the RDF examples.
https://www.w3.org/TR/turtle/

=== XII · References | References: modeling and queries
[10] **JSON-LD 1.1.** W3C Recommendation, 2020. Contexts and JSON-based linked-data serialization.
https://www.w3.org/TR/json-ld11/

[11] **RDF Schema 1.1.** W3C Recommendation, 2014. Classes, subclass, subproperty, domain, and range.
https://www.w3.org/TR/rdf-schema/

[12] **SPARQL 1.1 Entailment Regimes.** W3C Recommendation, 2013. Relationship between semantic entailment and query answers.
https://www.w3.org/TR/sparql11-entailment/

[13] **SKOS Simple Knowledge Organization System Primer.** W3C Working Group Note, 2009. Concepts, labels, and semantic relations.
https://www.w3.org/TR/skos-primer/

[14] **OWL 2 Structural Specification and Functional-Style Syntax, Second Edition.** W3C Recommendation, 2012. Axioms, class expressions, and ontology structure.
https://www.w3.org/TR/owl2-syntax/

[15] **OWL 2 Direct Semantics, Second Edition.** W3C Recommendation, 2012. Formal interpretation and model-theoretic meaning.
https://www.w3.org/TR/owl2-direct-semantics/

[16] **RDF 1.1 Semantics.** W3C Recommendation, 2014. RDF/RDFS interpretation, entailment, and reification considerations.
https://www.w3.org/TR/rdf11-mt/

[17] **OWL 2 Profiles, Second Edition.** W3C Recommendation, 2012. EL, QL, and RL profile definitions and intended computational properties.
https://www.w3.org/TR/owl2-profiles/

[18] **SPARQL 1.1 Update.** W3C Recommendation, 2013. Insert, delete, and graph-management operations.
https://www.w3.org/TR/sparql11-update/

[19] **SPARQL 1.1 Federated Query.** W3C Recommendation, 2013. Remote SERVICE pattern evaluation.
https://www.w3.org/TR/sparql11-federated-query/

[20] **Cypher Manual: Property, Structural, and Constructed Values, version 5.** Neo4j documentation. Nodes, relationships, paths, and value categories.
https://neo4j.com/docs/cypher-manual/5/values-and-types/property-structural-constructed/

=== XII · References | References: implementation and architecture
[21] **Cypher Manual: MERGE, version 5.** Neo4j documentation. Match-or-create behavior and constraint interactions.
https://neo4j.com/docs/cypher-manual/5/clauses/merge/

[22] **Cypher Manual: MATCH, version 5.** Neo4j documentation. Pattern matching and paths.
https://neo4j.com/docs/cypher-manual/5/clauses/match/

[23] **Cypher Manual: OPTIONAL MATCH, version 5.** Neo4j documentation. Optional pattern behavior.
https://neo4j.com/docs/cypher-manual/5/clauses/optional-match/

[24] **Cypher Manual: Working with null, version 5.** Neo4j documentation. Null expression behavior and missing properties.
https://neo4j.com/docs/cypher-manual/5/values-and-types/working-with-null/

[25] **PROV-O: The PROV Ontology.** W3C Recommendation, 2013. Provenance entities, activities, agents, and their relations.
https://www.w3.org/TR/prov-o/

[26] **R2RML: RDB to RDF Mapping Language.** W3C Recommendation, 2012. Relational-to-RDF mapping and implementation approaches.
https://www.w3.org/TR/r2rml/

[27] **Cypher Manual: Query Plans, Tuning, and Caching, version 5.** Neo4j documentation, checked for this edition. Profiling and planning entry point; consult the matching installed version.
https://neo4j.com/docs/cypher-manual/5/planning-and-tuning/

[28] **Operations Manual: Database Transactions.** Rolling Neo4j documentation, checked for this edition. This link is not a version-5 archive; verify behavior against the installed release and the recorded 5.26.30 fixture run. Operational transaction behavior; consult the installed release.
https://neo4j.com/docs/operations-manual/current/database-internals/transaction-management/

=== XII · References | References: governance, RAG, and further study
[29] **Data Catalog Vocabulary (DCAT), Version 3.** W3C Recommendation, 22 August 2024. Dataset and distribution metadata.
https://www.w3.org/TR/vocab-dcat-3/

[30] **From Local to Global: A Graph RAG Approach to Query-Focused Summarization.** Edge et al., 2024; revised 2025. Research example using graph-derived communities and summaries. This is one approach, not a definition of all graph RAG systems.
https://arxiv.org/abs/2404.16130

[31] **GraphRAG for Python Documentation.** Rolling Python-library documentation, checked for this edition; the library has its own versioning, separate from Cypher 5. No dependency-specific GraphRAG implementation is executed in this tutorial. Practical pipeline and retriever implementation reference; APIs and supported versions can change.
https://neo4j.com/docs/neo4j-graphrag-python/current/

[32] **Graph Data Science: Graph Algorithms.** Rolling GDS-library documentation, checked for this edition; GDS versions are separate from Cypher 5. Algorithm descriptions are orientation, not a tested GDS deployment. Algorithm categories and implementation entry point.
https://neo4j.com/docs/graph-data-science/current/algorithms/

[33] **Apache Jena: TDB2.** Official documentation, checked 13 November 2026. RDF storage and query component.
https://jena.apache.org/documentation/tdb2/

[34] **Apache Jena Fuseki.** Official documentation, checked 13 November 2026. SPARQL server and storage integration.
https://jena.apache.org/documentation/fuseki2/

[35] **RDF4J: The Repository API.** Official documentation, checked 13 November 2026. Repository interfaces, storage choices, and configuration-dependent inference.
https://rdf4j.org/documentation/programming/repository/
