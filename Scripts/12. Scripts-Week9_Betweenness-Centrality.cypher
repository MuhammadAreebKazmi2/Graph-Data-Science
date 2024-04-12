// https://neo4j.com/docs/graph-data-science/current/algorithms/betweenness-centrality/
// source

CREATE
  (alice:User {name: 'Alice'}),
  (bob:User {name: 'Bob'}),
  (carol:User {name: 'Carol'}),
  (dan:User {name: 'Dan'}),
  (eve:User {name: 'Eve'}),
  (frank:User {name: 'Frank'}),
  (gale:User {name: 'Gale'}),

  (alice)-[:FOLLOWS {weight: 1.0}]->(carol),
  (bob)-[:FOLLOWS {weight: 1.0}]->(carol),
  (carol)-[:FOLLOWS {weight: 1.0}]->(dan),
  (carol)-[:FOLLOWS {weight: 1.3}]->(eve),
  (dan)-[:FOLLOWS {weight: 1.0}]->(frank),
  (eve)-[:FOLLOWS {weight: 0.5}]->(frank),
  (frank)-[:FOLLOWS {weight: 1.0}]->(gale);

CALL gds.betweenness.write.estimate('myGraph', { writeProperty: 'betweenness' })
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

CALL gds.betweenness.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY name ASC

MATCH (n)
RETURN n

CALL gds.betweenness.stats('myGraph')
YIELD centralityDistribution
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore

CALL gds.betweenness.mutate('myGraph', {mutateProperty: 'betweenness'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

CALL gds.betweenness.write('myGraph', {writeProperty: 'betweenness'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS MinScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

CALL gds.graph.project('myUndirectedGraph', 'User', {FOLLOWS: {orientation: 'UNDIRECTED'}})

CALL gds.betweenness.stream('myGraph', {samplingSize: 2, samplingSeed: 0})
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY name ASC

CALL gds.betweenness.stream('myUndirectedGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY name ASC

CALL gds.betweenness.stream('myGraph', {relationshipWeightProperty: 'weight'})
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score
ORDER BY name ASC
