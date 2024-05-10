CALL gds.graph.project(
    'areaGraph', 
    {
        Area: { 
            label: 'Area' 
        }
    },
    {
        Contains: {
            type: 'Contains',
            orientation: 'UNDIRECTED'
        },
        Occurs_in: {
            type: 'Occurs_in',
            orientation: 'UNDIRECTED'
        },
        Took_place_in: {
            type: 'Took_place_in',
            orientation: 'UNDIRECTED'
        }
    }
);

CALL gds.pageRank.stream('areaGraph', {
    maxIterations: 20,
    dampingFactor: 0.85
})
YIELD nodeId, score
// Convert the nodeId back to the node and retrieve the AREA property and AREA NAME property
RETURN gds.util.asNode(nodeId).AREA AS areaId, 
       gds.util.asNode(nodeId).`AREA NAME` AS areaName, 
       score
ORDER BY score DESC
LIMIT 10;
// Area 1, 5, 9 are highly important


// *********** AREA | Case ************/
CALL gds.graph.project(
    'caseAreaGraph',
    {
        Case: {
            label: 'Case',
            properties: ['DR_NO']  // Case number property
        },
        Area: {
            label: 'Area',
            properties: ['AREA']  // Area identifier property
        }
    },
    {
        Occurs_in: {
            type: 'Occurs_in',
            orientation: 'UNDIRECTED'
        }
    }
);

CALL gds.louvain.stream('caseAreaGraph', {})
YIELD nodeId, communityId
WITH nodeId, communityId, gds.util.asNode(nodeId) AS node
WHERE node:Case  // Filter to only include Case nodes
RETURN node.DR_NO AS Case_No, communityId
ORDER BY communityId;

MATCH (a:Area)<-[:Occurs_in]-(c:Case)
WITH a.AREA AS area, count(c) AS caseCount
RETURN area, caseCount
ORDER BY caseCount DESC;

// just confirmed that that the case lied in the area with most cases (2nd) and lied in the communityId
MATCH (c:Case {DR_NO: 10304468})-[r]-(m)
RETURN c, r, m

// ************************************************************


// ******************* highlights most important crimes ***************
CALL gds.graph.project(
    'crimeProjection',
    ['Crime', 'Victim', 'Weapon'],
    {
        Affected_by: {
            type: 'Affected_by',
            orientation: 'UNDIRECTED'
        },
        Involves_weapon: {
            type: 'Involves_weapon',
            orientation: 'UNDIRECTED'
        }
    }
)

CALL gds.pageRank.stream('crimeProjection', {
    maxIterations: 20, // You can adjust this value as needed
    dampingFactor: 0.85 // Damping factor commonly used for PageRank
})
YIELD nodeId, score
MATCH (n:`Crime`) WHERE id(n) = nodeId
RETURN n.`Crm Cd` AS crimeId, n.`Crm Cd Desc` AS crimeDescription, score
ORDER BY score DESC
LIMIT 10;













