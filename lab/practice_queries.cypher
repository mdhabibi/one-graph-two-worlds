// Task 1
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

// Task 2
MATCH (:Person {id: 'maya'})-[:COMPLETED]->(c:Course)
RETURN c.id AS id, c.title AS title ORDER BY id;

// Task 3
MATCH (c:Course)-[:ABOUT]->(t:Topic)
WHERE t.id <> 'ethics'
RETURN t.id AS topic, count(DISTINCT c) AS courses
ORDER BY courses DESC, topic;
