// Source:
// https://neo4j.com/docs/graph-data-science/current/algorithms/closeness-centrality/#algorithms-closeness-centrality-examples-stream

CREATE (a:Node {id:"A"}),
       (b:Node {id:"B"}),
       (c:Node {id:"C"}),
       (d:Node {id:"D"}),
       (e:Node {id:"E"}),
       (a)-[:LINK]->(b),
       (b)-[:LINK]->(a),
       (b)-[:LINK]->(c),
       (c)-[:LINK]->(b),
       (c)-[:LINK]->(d),
       (d)-[:LINK]->(c),
       (d)-[:LINK]->(e),
       (e)-[:LINK]->(d);

CALL gds.graph.project('myGraph', 'Node', 'LINK')

CALL gds.closeness.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).id AS id, score
ORDER BY score DESC

CALL gds.closeness.stats('myGraph')
YIELD centralityDistribution
RETURN centralityDistribution.min AS minScore, centralityDistribution.mean AS meanScore

CALL gds.closeness.mutate('myGraph', { mutateProperty: 'centrality' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten

CALL gds.closeness.write('myGraph', { writeProperty: 'centrality' })
YIELD centralityDistribution, nodePropertiesWritten
RETURN centralityDistribution.min AS minimumScore, centralityDistribution.mean AS meanScore, nodePropertiesWritten