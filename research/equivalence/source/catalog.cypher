// Neo4j 5-compatible baseline. Run in a dedicated exercise database.
// Execute each semicolon-terminated statement separately if required by your UI.
CREATE CONSTRAINT person_id IF NOT EXISTS
FOR (p:Person) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT course_id IF NOT EXISTS
FOR (c:Course) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT topic_id IF NOT EXISTS
FOR (t:Topic) REQUIRE t.id IS UNIQUE;

UNWIND [{id:'maya',name:'Maya'},{id:'leo',name:'Leo'}] AS row
MERGE (p:Person {id:row.id}) SET p.name=row.name;

UNWIND [{id:'graphs',name:'Graphs'},{id:'data',name:'Data'},
        {id:'ethics',name:'Ethics'}] AS row
MERGE (t:Topic {id:row.id}) SET t.name=row.name;

UNWIND [{id:'c1',title:'Graph Basics',minutes:60},
        {id:'c2',title:'Graph Search',minutes:90},
        {id:'c3',title:'Query Patterns',minutes:75},
        {id:'c4',title:'Data Ethics',minutes:45}] AS row
MERGE (c:Course {id:row.id})
SET c.title=row.title, c.durationMinutes=row.minutes;

UNWIND [{person:'maya',topic:'graphs'},{person:'leo',topic:'data'}] AS row
MATCH (p:Person {id:row.person}), (t:Topic {id:row.topic})
MERGE (p)-[:LIKES_TOPIC]->(t);

UNWIND ['maya','leo'] AS personId
MATCH (p:Person {id:personId}), (c:Course {id:'c1'})
MERGE (p)-[:COMPLETED]->(c);

UNWIND [{course:'c1',topic:'graphs'},{course:'c2',topic:'graphs'},
        {course:'c3',topic:'data'},{course:'c4',topic:'ethics'}] AS row
MATCH (c:Course {id:row.course}), (t:Topic {id:row.topic})
MERGE (c)-[:ABOUT]->(t);

UNWIND ['c2','c3'] AS courseId
MATCH (c:Course {id:courseId}), (r:Course {id:'c1'})
MERGE (c)-[:REQUIRES]->(r);
