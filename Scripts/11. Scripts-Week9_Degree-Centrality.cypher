// https://neo4j.com/docs/graph-data-science/current/algorithms/degree-centrality/
// source

CREATE
  (alice:User {name: 'Alice'}),
  (bridget:User {name: 'Bridget'}),
  (charles:User {name: 'Charles'}),
  (doug:User {name: 'Doug'}),
  (mark:User {name: 'Mark'}),
  (michael:User {name: 'Michael'}),

  (alice)-[:FOLLOWS {score: 1}]->(doug),
  (alice)-[:FOLLOWS {score: -2}]->(bridget),
  (alice)-[:FOLLOWS {score: 5}]->(charles),
  (mark)-[:FOLLOWS {score: 1.5}]->(doug),
  (mark)-[:FOLLOWS {score: 4.5}]->(michael),
  (bridget)-[:FOLLOWS {score: 1.5}]->(doug),
  (charles)-[:FOLLOWS {score: 2}]->(doug),
  (michael)-[:FOLLOWS {score: 1.5}]->(doug)

// display graph
MATCH (n)-[]-(m)
RETURN n,m

CALL gds.graph.project(
    'myGraph',
    'User',
    {
        FOLLOWS: {
            orientation: 'REVERSE',
            properties: ['score']
        }
    }
)

CALL gds.degree.write.estimate('myGraph', {writeProperty: 'degree'})
YIELD nodeCount, relationshipCount, bytesMin, bytesMax, requiredMemory

CALL gds.degree.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score AS followers
ORDER BY followers DESC, name DESC

CALL gds.degree.stats('myGraph')
YIELD centralityDistribution
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore

CALL gds.degree.mutate('myGraph', {mutateProperty: 'degree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore,  nodePropertiesWritten

CALL gds.degree.write('myGraph', {writeProperty: 'degree'})
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore,  nodePropertiesWritten

// wrote the query to show that indeed degree had been written to nodes
MATCH(n)-[]-(m)
RETURN n, m

CALL gds.degree.stream(
    'myGraph',
    {relationshipWeightProperty: 'score'}
)
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score as WeightedFollowers
ORDER BY WeightedFollowers DESC, name DESC

CALL gds.degree.stream(
   'myGraph',
   { orientation: 'REVERSE' }
)
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS name, score AS followees
ORDER BY followees DESC, name DESC