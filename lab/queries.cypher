// 1. Graph courses: c1, c2
MATCH (c:Course)-[:ABOUT]->(:Topic {id:'graphs'})
RETURN c.id AS id, c.title AS title ORDER BY id;

// 2. Short courses (maxMinutes=75): c1, c3, c4
MATCH (c:Course) WHERE c.durationMinutes <= $maxMinutes
RETURN c.id AS id ORDER BY id;

// 3. Topic counts: graphs 2, data 1, ethics 1
MATCH (c:Course)-[:ABOUT]->(t:Topic)
RETURN t.id AS topic, count(DISTINCT c) AS courses
ORDER BY courses DESC, topic;

// 4. Prerequisite of c2: c1
MATCH (:Course {id:'c2'})-[:REQUIRES*1..5]->(r:Course)
RETURN DISTINCT r.id AS required ORDER BY required;

// 5. Recommendation: c2 / Graph Search
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
