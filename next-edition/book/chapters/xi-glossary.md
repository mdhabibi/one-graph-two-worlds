# XI · Glossary

## 11.1 Glossary A–D

**ACID:** atomicity, consistency, isolation, and durability; a family of transaction properties. Consistency concerns enforced invariants, not factual truth.

**Aggregation:** combining solution rows into summaries such as counts or averages. Choose the counting unit before interpreting a result.

**Architecture decision record (ADR):** a record of a design's context, alternatives, evidence, decision, consequences, and revisit conditions.

**Assertion / axiom:** an assertion states a fact; an axiom states a formal commitment. Usage can overlap in ontology languages.

**Bijection:** a one-to-one correspondence that covers both selected sets. In the query contract, each selected RDF identity has exactly one corresponding LPG node, with no unmatched query-relevant node.

**Blank node:** an RDF resource term without a global IRI. A serialized blank-node label is not a durable cross-file business identifier.

**Canonical identifier:** the preferred identity used after reconciling source-specific identifiers. It requires a scope and a merge policy.

**Cardinality:** either the number of matches in a query stage or a constraint on how many related values may exist; distinguish the context.

**Class / instance:** a category and an individual member of that category. A label may represent a class in an LPG by convention.

**Closed-world policy:** treating a declared dataset as complete for a defined decision. It is not automatically the global semantics of a graph database.

**Competency question:** a concrete question a model must answer, used to guide design and validate usefulness.

**Constraint:** a rule checked by a validation or storage mechanism. Name the enforcement point and failure behavior.

**Coreference:** whether expressions refer to the same entity within a context; name similarity alone does not establish it.

**Cypher:** the declarative graph query language used for Neo4j examples. Patterns bind nodes, relationships, paths, and values.

**Data contract:** an agreement covering structure, meaning, units, identity, quality, and ownership. It is broader than a list of fields.

**Dataset / named graph:** in RDF, a dataset contains a default graph and zero or more named graphs. A graph name does not itself establish trust or permission.

**Datatype:** a defined value space and lexical representation, such as integer or dateTime. A datatype-tagged literal differs from a plain string.

**Description logic:** a formal framework for representing and reasoning about classes, relations, and individuals; foundational to OWL DL.

## 11.2 Glossary E–L

**Effective time:** when a definition or policy applies under its stated time-selection rule; it is distinct from when the change was recorded.

**Eligibility / suitability:** eligibility satisfies a stated policy under its data assumptions; personal suitability is a broader, context-dependent claim requiring separately defined and evaluated criteria.

**Embedding:** a numeric vector representing content or an entity for computation such as similarity search. Similarity is not proof of truth.

**Entailment / inference:** entailment is a logical consequence relation; inference is the process of deriving consequences under a chosen regime.

**Entity resolution / entity linking:** resolution decides which records refer to the same thing; linking connects a mention or record to an identified entity.

**Event node:** an identified occurrence modeled as a node, allowing participants, time, evidence, and lifecycle to be represented explicitly.

**Fan-out / degree:** fan-out is the expansion considered at a query step; degree counts a node's incident connections under a specified definition.

**Federation:** querying or coordinating multiple sources. It requires policies for permissions, failures, and inconsistent snapshot times.

**Fixture integrity:** stronger rules and state comparisons for an experimental dataset. It can reject a difference that the query-alignment contract deliberately ignores.

**Focus node:** the node being evaluated by a SHACL shape. Targets determine which nodes become focus nodes.

**Formal semantics:** a precise account of what statements mean and which interpretations or consequences they permit.

**Graph projection:** a selected or transformed graph view for analytics or application use. Define source authority and rebuild rules.

**Graph RAG:** a family of retrieval-augmented generation designs using graph structure for organizing or retrieving evidence or summaries.

**Grounding:** connecting generated claims to supplied evidence. It requires checking support, not merely attaching a link.

**Identity / equality:** the claim that references denote the same entity. In OWL, sameAs has stronger consequences than approximate similarity.

**Identity registry:** governed identifiers and distinguishing information for entities; a class/property vocabulary need not supply those individual identities.

**Index:** a lookup structure that can accelerate selected access patterns, with storage and update costs.

**IRI:** Internationalized Resource Identifier; a globally scoped identifier syntax used for RDF resources and vocabulary terms.

**Join:** combining solutions through compatible shared values. Query engines may implement it with different physical strategies.

**Knowledge graph:** a graph representation of entities, relations, and usable meaning or context. The term has multiple definitions.

**Labeled property graph (LPG):** a graph model with labeled nodes, directed typed relationships, and stored properties. Neo4j is one implementation.

**Literal:** an RDF value term with a datatype. A language-tagged string also has a language tag and datatype rdf:langString. It differs from an IRI naming a resource.

## 11.3 Glossary M–R

**Mapping / round trip:** a mapping translates representations; a round trip exports and reconstructs data. Preservation must be defined for the required distinctions.

**Materialization:** precomputing and storing inferred facts or derived views. Faster reads may incur extra maintenance and storage.

**Mention:** an occurrence of an expression in a particular source version, identified with its context and locator; it is distinct from the entity it may denote.

**Migration:** a controlled transition between representations or versions, with defined preservation, acceptance and recovery conditions.

**Monotonicity:** the property that adding premises preserves previous logical consequences. Absence-based application policies need not be monotonic.

**Multiset:** a collection allowing repeated values or solution rows. RDF graphs are sets of triples, while SPARQL results can have duplicates.

**Namespace:** a governed identifier space for terms. Prefixes abbreviate namespace IRIs but are not the identifiers themselves.

**Ontology:** an explicit model of concepts, relations, and commitments about meaning. Ontology engineering is the design process; a reasoner executes formal reasoning tasks.

**Ontology version:** an identified release of an ontology; a version IRI can distinguish it within an ontology series. Version labels alone do not prove compatibility.

**Open-world assumption:** the absence of a fact does not imply its negation. A query over a selected dataset can still test whether a pattern is absent.

**OWL:** Web Ontology Language, used to express formal ontology axioms. OWL 2 EL, QL, and RL are restricted profiles with different computational aims.

**Path / hop:** a path connects graph elements through steps; a hop is one relationship step. Endpoints, routes, and walks are different query outputs.

**Policy version:** an identified decision-rule release, retained with its effective interval and the context used to select it.

**Predicate / property:** in RDF, a predicate IRI names a relation or attribute. In LPG usage, a property is usually a stored key–value attribute.

**Preservation and reflection:** a mapped fact exists in the source if and only if the corresponding fact exists in the destination. Preservation avoids losing source facts; reflection rules out unmatched destination facts.

**Provenance / lineage:** provenance records origin and responsibility; lineage traces transformations from inputs to outputs.

**Query alignment:** correspondence of the identities, memberships, relationships, anchor and projected values needed by a specified query pair. It is distinct from intake validation and stronger fixture integrity.

**Query rewriting:** transforming a query using schema or ontology knowledge so additional implied answers can be computed without fully materializing closure.

**RAG:** retrieval-augmented generation; supplying selected evidence to a language model during answer generation.

**RDF / RDFS:** Resource Description Framework is a statement-based data model; RDF Schema supplies basic vocabulary and entailment constructs.

**Reasoner:** software that computes semantic consequences, classifications, satisfiability, or consistency under a supported logic.

**Reification:** representing a statement or relation as a describable resource. RDF 1.1 statement reification does not itself assert the described triple.

## 11.4 Glossary S–Z and notation

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

