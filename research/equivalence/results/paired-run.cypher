MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;

CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C01-baseline' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C01-baseline' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (a:Course {id:'c2'}),(b:Course {id:'c4'}) CREATE (a)-[:REQUIRES]->(b);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C02-unmet-prerequisite' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C02-unmet-prerequisite' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C03-already-completed' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C03-already-completed' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}),(c:Course {id:'c2'}) CREATE (m)-[:LIKES_TOPIC]->(t) CREATE (c)-[:ABOUT]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C04-two-matching-topics' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C04-two-matching-topics' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (t:Topic {id:'graphs'}) REMOVE t:Topic;
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C05-untyped-topic' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C05-untyped-topic' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (c:Course {id:'c2'}) REMOVE c.title;
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C06-missing-title' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C06-missing-title' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (m:Person {id:'maya'}) REMOVE m:Person;
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C07-untyped-learner' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C07-untyped-learner' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (c:Course {id:'c2'}) CREATE (c)-[:REQUIRES]->({id:'c9'});
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C08-non-Course-prerequisite' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C08-non-Course-prerequisite' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (c:Course {id:'c2'}) CREATE (c)-[:REQUIRES]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C09-self-prerequisite' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C09-self-prerequisite' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (a:Course {id:'c1'}),(b:Course {id:'c4'}) CREATE (a)-[:REQUIRES]->(b);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C10-direct-not-transitive-policy' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C10-direct-not-transitive-policy' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (c:Course {id:'c2'}) REMOVE c.id;
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C11-missing-id' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C11-missing-id' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (c:Course {id:'c2'}) SET c.title=['Graph Search','Alternate title'];
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-B01-multivalued-title' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'B01-multivalued-title' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-B02-parallel-completions' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'B02-parallel-completions' AS case_id, result_rows AS rows;
MATCH (:Person {id:'maya'})-[r:COMPLETED]->() RETURN 'D-parallel-count' AS case_id, count(r) AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (c:Course {id:'c2'}) REMOVE c:Course SET c:OnlineCourse;
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-B03-asymmetric-inference' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'B03-asymmetric-inference' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (e1:Completion {id:'e1'})-[:LEARNER]->(m) CREATE (e1)-[:COURSE]->(c) CREATE (e2:Completion {id:'e2'})-[:LEARNER]->(m) CREATE (e2)-[:COURSE]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-B04-explicit-completion-events' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'B04-explicit-completion-events' AS case_id, result_rows AS rows;
MATCH (e:Completion)-[:LEARNER]->(:Person {id:'maya'}), (e)-[:COURSE]->(:Course {id:'c1'}) RETURN 'D-event-count' AS case_id, count(DISTINCT e) AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r;
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-000' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-000' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-001' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-001' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-002' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-002' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-003' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-003' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-010' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-010' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-011' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-011' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-012' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-012' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-013' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-013' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-020' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-020' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-021' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-021' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-022' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-022' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-023' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-023' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-030' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-030' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-031' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-031' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-032' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-032' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-033' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-033' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-040' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-040' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-041' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-041' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-042' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-042' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-043' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-043' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-050' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-050' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-051' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-051' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-052' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-052' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-053' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-053' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-060' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-060' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-061' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-061' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-062' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-062' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-063' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-063' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-070' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-070' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-071' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-071' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-072' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-072' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-073' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-073' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-100' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-100' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-101' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-101' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-102' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-102' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-103' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-103' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-110' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-110' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-111' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-111' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-112' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-112' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-113' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-113' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-120' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-120' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-121' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-121' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-122' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-122' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-123' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-123' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-130' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-130' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-131' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-131' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-132' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-132' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-133' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-133' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-140' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-140' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-141' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-141' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-142' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-142' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-143' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-143' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-150' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-150' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-151' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-151' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-152' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-152' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-153' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-153' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-160' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-160' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-161' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-161' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-162' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-162' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-163' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-163' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-170' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-170' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-171' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-171' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-172' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-172' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-173' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-173' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-200' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-200' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-201' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-201' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-202' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-202' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-203' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-203' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-210' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-210' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-211' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-211' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-212' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-212' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-213' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-213' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-220' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-220' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-221' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-221' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-222' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-222' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-223' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-223' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-230' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-230' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-231' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-231' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-232' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-232' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-233' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-233' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-240' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-240' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-241' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-241' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-242' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-242' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-243' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-243' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-250' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-250' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-251' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-251' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-252' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-252' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-253' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-253' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-260' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-260' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-261' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-261' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-262' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-262' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-263' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-263' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-270' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-270' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-271' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-271' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-272' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-272' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-273' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-273' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-300' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-300' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-301' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-301' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-302' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-302' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-303' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-303' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-310' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-310' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-311' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-311' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-312' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-312' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-313' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-313' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-320' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-320' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-321' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-321' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-322' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-322' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-323' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-323' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-330' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-330' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-331' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-331' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-332' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-332' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-333' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-333' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-340' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-340' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-341' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-341' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-342' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-342' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-343' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-343' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-350' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-350' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-351' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-351' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-352' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-352' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-353' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-353' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-360' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-360' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-361' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-361' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-362' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-362' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-363' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-363' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-370' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-370' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-371' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-371' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-372' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-372' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (:Course {id:'c2'})-[r:REQUIRES]->() DELETE r; MATCH (:Person {id:'maya'})-[r:COMPLETED|LIKES_TOPIC]->() DELETE r; MATCH (c:Course {id:'c2'}),(p:Course {id:'c1'}) CREATE (c)-[:REQUIRES]->(p); MATCH (c:Course {id:'c2'}),(p:Course {id:'c3'}) CREATE (c)-[:REQUIRES]->(p); MATCH (m:Person {id:'maya'}),(c:Course {id:'c1'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c2'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(c:Course {id:'c3'}) CREATE (m)-[:COMPLETED]->(c); MATCH (m:Person {id:'maya'}),(t:Topic {id:'data'}) CREATE (m)-[:LIKES_TOPIC]->(t); MATCH (m:Person {id:'maya'}),(t:Topic {id:'graphs'}) CREATE (m)-[:LIKES_TOPIC]->(t);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-G-373' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'G-373' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (c:Course {id:'c2'}),(r:Course {id:'c3'}),(m:Person {id:'maya'}) CREATE (c)-[:REQUIRES]->(r) CREATE (m)-[:COMPLETED]->(r);
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C12-all-multiple-prerequisites-completed' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C12-all-multiple-prerequisites-completed' AS case_id, result_rows AS rows;
MATCH (n) DETACH DELETE n;
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

MATCH (n) SET n._source=n.id;
MATCH (c:Course {id:'c2'}) SET c:OnlineCourse;
CALL { MATCH (n) RETURN collect([coalesce(n._source,n.id),labels(n),CASE WHEN n.id IS NULL THEN [] ELSE [n.id] END,CASE WHEN n.title IS NULL THEN [] ELSE [n.title] END]) AS ns }
CALL { MATCH (a)-[r]->(b) RETURN collect([coalesce(a._source,a.id),type(r),coalesce(b._source,b.id)]) AS es }
RETURN 'S-C13-aligned-membership-control' AS case_id,[ns,es] AS rows;
CALL { CALL { MATCH (m:Person {id: 'maya'})-[:LIKES_TOPIC]->(t)
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
ORDER BY id } RETURN collect([id,title]) AS result_rows } RETURN 'C13-aligned-membership-control' AS case_id, result_rows AS rows;