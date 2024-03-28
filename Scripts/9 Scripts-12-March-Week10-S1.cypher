// project
// graph data model
// map the data into there
// define what will be your node classification and your node prediction algorithm
// wrapper app which provides interaction
// can be console based
// wrapper app is expected to connect the graph, and show the results


// 1.
CALL gds.graph.project(
    'native-proj',
    ['Person', 'Movie'],
    {ACTED: {
        orientation:"UNDIRECTED",
        type: 'ACTED_IN'}
    }
);

// 2.
CALL gds.degree.stream('native-proj')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).url AS url, score AS degree
ORDER BY degree ASC

// 3. 
CALL gds.pageRank.stream('native-proj')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).url AS url, score AS pagerank
ORDER BY pagerank DESC

// 4.
CALL gds.closeness.stream('native-proj')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).username AS username, score AS closeness
ORDER BY closeness DESC

// 5. 
CALL gds.closeness.stream('native-proj')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId) AS username, score AS closeness
ORDER BY closeness DESC
LIMIT 5



