CALL gds.graph.project(
    'case-project',
    {
        Case: {
            properties: 'DR_NO'
        },
        Crime: {
            properties: 'Crm Cd'
        }
    },
    {
        TYPE: {
            type: 'Type'
        }
    }
)


CALL gds.alpha.ml.splitRelationships.mutate('case-project', {
  relationshipTypes: ['TYPE'],
  remainingRelationshipType: 'Similar_to',
  holdoutRelationshipType: 'CRIME_TESTGRAPH',
  holdoutFraction: 0.2,
  negativeSamplingRatio: 1.0 
})
YIELD relationshipsWritten
RETURN relationshipsWritten;


CALL gds.pageRank.mutate('case-project', {
    maxIterations: 20,
    dampingFactor: 0.05,
    relationshipTypes: ["TYPE"],
    mutateProperty: 'pagerank'
})
YIELD nodePropertiesWritten, computeMillis
RETURN nodePropertiesWritten, computeMillis;


CALL gds.fastRP.mutate('case-project', {
    embeddingDimension: 250,
    relationshipTypes: ["Similar_to"],
    iterationWeights: [0, 0, 1.0, 1.0],
    normalizationStrength:0.05,
    mutateProperty: 'fastRP_Embedding'
})
YIELD nodePropertiesWritten, mutateMillis, nodeCount, computeMillis;

