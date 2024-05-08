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


Call gds.beta.pipeline.nodeClassification.create('case-pipeline')


CALL gds.pipeline.list('case-pipeline')


CALL gds.beta.pipeline.nodeClassification.selectFeatures("case-pipeline", "DR_NO"
);


CALL gds.beta.pipeline.nodeClassification.configureSplit("case-pipeline", {
    testFraction: 0.2,
    validationFolds: 5
});



CALL gds.beta.pipeline.nodeClassification.addLogisticRegression("case-pipeline", {
    maxEpochs: 200,
    penalty: {
        range: [0.0, 0.5]
    }
});


CALL gds.beta.pipeline.nodeClassification.train.estimate(
    'case-project',
    {
        pipeline: "case-pipeline",
        modelName: "case-pipeline-model",
        targetNodeLabels: ["Case"],
        targetProperty: "DR_NO",
        metrics: ["F1_WEIGHTED"],
        randomSeed: 42,
        concurrency: 4
    }
);


CALL gds.beta.pipeline.nodeClassification.train(
    'case-project',
    {
        pipeline: "case-pipeline",
        modelName: "case-pipeline-model",
        targetNodeLabels: ["Case"],
        targetProperty: "DR_NO",
        metrics: ["F1_WEIGHTED"],
        randomSeed: 42,
        concurrency: 4
    }
);


CALL gds.beta.pipeline.nodeClassification.predict.stream(
    'case-project',
    {
        modelName: 'case-pipeline-model',
        targetNodeLabels: ['Case'],
        includePredictedProbabilities: true
    }
)
YIELD nodeId, predictedLabel, predictedProbabilities
RETURN nodeId, predictedLabel, predictedProbabilities;








