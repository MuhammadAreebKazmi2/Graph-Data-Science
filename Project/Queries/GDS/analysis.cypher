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
//-- Convert the nodeId back to the node and retrieve the AREA property (or other relevant properties as needed)
RETURN gds.util.asNode(nodeId).AREA AS areaId, score
ORDER BY score DESC
LIMIT 10;
// Area 1, 5, 9 are highly important


CALL gds.graph.project(
    'communityGraphs',
    {
        Case: {
            label: 'Case',
            properties: ['DR_NO']  
        },
        Area: {
            label: 'Area',
            properties: ['AREA'] 
        },
        Location: {
            label: 'Location',
            properties: ['Location_id'] 
        }
    },
    {
        Occurs_in: {
            type: 'Occurs_in',
            orientation: 'UNDIRECTED'
        },
        Occurs_at: {
            type: 'Occurs_at',
            orientation: 'UNDIRECTED'
        }
    }
);

CALL gds.louvain.stream('communityGraph', {})
YIELD nodeId, communityId
RETURN gds.util.asNode(nodeId).AREA AS areaId, communityId
ORDER BY communityId;




CALL gds.graph.project(
    'victimCrimeWeaponGraph',
    {
        Victim: {
            label: 'Victim',
            properties: ['Victim_id']
        },
        Crime: {
            label: 'Crime',
            properties: ['Crm Cd']
        },
        Weapon: {
            label: 'Weapon',
            properties: ['Weapon Used Cd']
        }
    },
    {
        Affected_by: {
            type: 'Affected_by'
        },
        Committed_against: {
            type: 'Committed_against'
        },
        Used_in: {
            type: 'Used_in'
        },
        Involves_weapon: {
            type: 'Involves_weapon'
        }
    }
);


CALL gds.louvain.stream('victimCrimeWeaponGraph', {})
YIELD nodeId, communityId
RETURN gds.util.asNode(nodeId).id AS nodeId, gds.util.asNode(nodeId).labels AS labels, communityId
ORDER BY communityId;















