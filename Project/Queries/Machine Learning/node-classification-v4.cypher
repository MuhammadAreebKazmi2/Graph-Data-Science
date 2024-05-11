CALL gds.graph.project(
  'victim-graph',
  {
    Victim: {
      label: 'Victim',
      properties: ['Vict Age', 'Vict_Sex_encoded']
    },
    unknownVictim: {
      label: 'unknownVictim',
      properties: ['Vict Age']
    }
  },
  '*'
);

CALL gds.beta.pipeline.nodeClassification.create('pipeline-2')

CALL gds.beta.pipeline.nodeClassification.addNodeProperty(
    'pipeline-2',
    'scaleProperties',
    {
        nodeProperties: 'Vict Age',
        scaler: 'Mean',
        mutateProperty: 'scaledSizes'
    }
)
YIELD name, nodePropertySteps

CALL gds.beta.pipeline.nodeClassification.selectFeatures('pipeline-2', ['scaledSizes', 'Vict Age', 'Vict_Sex_encoded'])
YIELD name, featureProperties

CALL gds.beta.pipeline.nodeClassification.configureSplit('pipeline-2', {
  testFraction: 0.2,
  validationFolds: 5
})
YIELD splitConfig


CALL gds.beta.pipeline.nodeClassification.addRandomForest('pipeline-2', {numberOfDecisionTrees: 10})
YIELD parameterSpace

CALL gds.alpha.pipeline.nodeClassification.addMLP('pipeline-2', {classWeights: [0.4,0.3,0.3, 0.3], focusWeight: 0.5})
YIELD parameterSpace

CALL gds.beta.pipeline.nodeClassification.addLogisticRegression('pipeline-2', {maxEpochs: 500, penalty: {range: [1e-4, 1e2]}})
YIELD parameterSpace
RETURN parameterSpace.RandomForest AS randomForestSpace, parameterSpace.LogisticRegression AS logisticRegressionSpace, parameterSpace.MultilayerPerceptron AS MultilayerPerceptronSpace

CALL gds.alpha.pipeline.nodeClassification.configureAutoTuning('pipeline-2', {
  maxTrials: 2
}) 

MATCH (v:Victim)
WHERE v.Vict_Sex_encoded IS NULL OR v.Vict_Sex_encoded = 'NaN'
DETACH DELETE v;


CALL gds.beta.pipeline.nodeClassification.train('victim-graph', {
  pipeline: 'pipeline-2',
  targetNodeLabels: ['Victim'],
  modelName: 'victim-pipeline-model',
  targetProperty: 'Vict_Sex_encoded',
  randomSeed: 1227,
  metrics: ['ACCURACY']
}) 
YIELD modelInfo, modelSelectionStats
RETURN
  modelInfo.bestParameters AS winningModel,
  modelInfo.metrics.ACCURACY.train.avg AS avgTrainScore,
  modelInfo.metrics.ACCURACY.outerTrain AS outerTrainScore,
  modelInfo.metrics.ACCURACY.test AS testScore,
  [cand IN modelSelectionStats.modelCandidates | cand.metrics.ACCURACY.validation.avg] AS validationScores


CALL gds.beta.pipeline.nodeClassification.predict.stream('victim-graph', {
  modelName: 'victim-pipeline-model',
  includePredictedProbabilities: true,
  targetNodeLabels: ['unknownVictim']
})


CALL gds.beta.pipeline.nodeClassification.predict.mutate('victim-graph', {
  targetNodeLabels: ['unknownVictim'],
  modelName: 'victim-pipeline-model',
  mutateProperty: 'predictedClass',
  predictedProbabilityProperty: 'predictedProbabilities'
}) 
YIELD nodePropertiesWritten


CALL gds.beta.pipeline.nodeClassification.predict.write('victim-graph', {
  targetNodeLabels: ['unknownVictim'],
  modelName: 'victim-pipeline-model',
  writeProperty: 'predictedClass',
  predictedProbabilityProperty: 'predictedProbabilities'
}) 
YIELD nodePropertiesWritten