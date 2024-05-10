// Making certain nodes as unknownLocation nodes
MATCH(l:Location)
WITH l
LIMIT 40
SET l:unknownLocation
REMOVE l.Location_id

// pre-processing this so LocationCoordinates can be used to identify the LOCATION property
// made the LON and LAT as the 2D vector because both of them are important to 
MATCH (n:Location)
SET n.coordinates = [n.LON, n.LAT];


CALL gds.graph.project(
    'location-project',
    {
        Location: {properties: ['distanceFromOrigin', 'Location_id'] },
        unknownLocation: {properties: ['distanceFromOrigin']}
    },
    '*'
)
YIELD graphName

CALL gds.beta.pipeline.nodeClassification.create('pipeline-1')

CALL gds.beta.pipeline.nodeClassification.addNodeProperty(
    'pipeline-1',
    'scaleProperties',
    {
        nodeProperties: ['distanceFromOrigin'],
        scaler: 'Mean', // Mean scaling to standardize the property
        mutateProperty: 'standardizedDistanceFromOrigin'
    }
)
YIELD name, nodePropertySteps, featureProperties;

YIELD name, nodePropertySteps, featureProperties;

CALL gds.beta.pipeline.nodeClassification.configureSplit('pipeline-1', {
  testFraction: 0.2,
  validationFolds: 5
})


CALL gds.beta.pipeline.nodeClassification.addRandomForest('pipeline-1', {numberOfDecisionTrees: 10})
YIELD parameterSpace

CALL gds.alpha.pipeline.nodeClassification.addMLP('pipeline-1')
YIELD parameterSpace

CALL gds.beta.pipeline.nodeClassification.addLogisticRegression('pipeline-1')
YIELD parameterSpace
RETURN parameterSpace.RandomForest AS randomForestSpace, parameterSpace.LogisticRegression AS logisticRegressionSpace, parameterSpace.MultilayerPerceptron AS MultilayerPerceptronSpace

CALL gds.alpha.pipeline.nodeClassification.configureAutoTuning('pipeline-1', {
  maxTrials: 2
}) 

CALL gds.beta.pipeline.nodeClassification.train.estimate(
    'location-project',
    {
        pipeline: "pipeline-1",
        targetNodeLabels: ["Location"],
        modelName: "location-pipeline-model",
        targetProperty: "distanceFromOrigin",
        metrics: ["ACCURACY"],
        randomSeed: 42,
        concurrency: 2
    }
);

CALL gds.beta.pipeline.nodeClassification.train(
    'location-project',
    {
        pipeline: 'pipeline-1',
        targetNodeLabels: ['Location'],
        modelName: 'location-pipeline-model',
        targetProperty: 'Location_id',
        metrics: ['ACCURACY'],
        randomSeed: 42,
        concurrency: 2
    }
)

// not working
YIELD modelInfo, modelSelectionStats
RETURN
  modelInfo.bestParameters AS winningModel,
  modelInfo.metrics.ACCURACY.train.avg AS avgTrainScore,
  modelInfo.metrics.ACCURACY.outerTrain AS outerTrainScore,
  modelInfo.metrics.ACCURACY.test AS testScore,
  [cand IN modelSelectionStats.modelCandidates | cand.metrics.ACCURACY.validation.avg] AS validationScores



