CALL gds.list

CALL gds.graph.project(
    'native-proj',
    ['User'],
    "*"
)

CALL gds.graph.project(
    'native-proj',
    ['Movie'],
    "*"
)

CALL gds.graph.project(
    'native-proj',
    ['Person', 'Movie'],
    {RATED_BY: {
        type: 'RATED',
        orientation: 'REVERSE'}
    }
)

CALL gds.graph.project(
    'native-proj2',
    ['Person', 'Movie'],
    {RATED_BY: {
        type: 'RATED',
        orientation: 'REVERSE'}
    }
)

CALL gds.graph.project(
    'native-proj2',
    ['Person', 'Movie'],
    {ACTED_IN: {
        type: 'ACTED_IN',
        orientation: 'REVERSE'}
    }
)

// To aggregate multiple sme relations to one single relation
CALL gds.graph.project(
    'actor-proj',
    ['Person'],
    {
        ACTED_IN: {aggregation: 'SINGLE'}
    }
)

// To count relations AS WELL
CALL gds.graph.project(
    'actor-proj1',
    ['Person'],
    {
        ACTED_IN: {
            properties: {
                ACTED: {
                    property: '*',
                    aggregation: 'COUNT'
                }
            }
        }
    }
)


CALL gds.graph.project(
    'user-proj’,
    ['User’],
    {
        SENT_MONEY_TO: {
            properties: {
                numberOfTransactions: {
                    property: ‘amount’,
                    aggregation: ‘SUM’ }
            }
        }
    }
);

// CYPHER QUERIES
CALL gds.graph.project.cypher(
    'proj-cypher',
    'MATCH (a:Person) RETURN id(a) AS id, labels(a) AS labels',
    'MATCH (a1:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(a2)
        WHERE m.year >= 1990 AND m.revenue >= 1000000
        RETURN id(a1) AS source, id(a2) AS target, count(*) AS actedWithCount, "ACTED_WITH" AS type');


