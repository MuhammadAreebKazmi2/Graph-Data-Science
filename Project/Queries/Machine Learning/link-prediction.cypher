//Link prediction done on (Crime)-[:committed_against]->(victim)

Call gds.graph.project('LinkPred_Crime_Victm',
['Crime','Victim'],
[{Committed_against: {orientation:'UNDIRECTED'}}]
);
CALL gds.beta.pipeline.linkPrediction.create(
   'CrimeVictimPipeline'
);
CALL gds.beta.pipeline.linkPrediction.addNodeProperty('CrimeVictimPipeline', 'fastRP', {
  mutateProperty: 'embedding',
  embeddingDimension: 56,
  randomSeed: 42
}) YIELD nodePropertySteps;
CALL gds.beta.pipeline.linkPrediction.addNodeProperty('CrimeVictimPipeline','degree', {
  mutateProperty: 'degree'
})YIELD nodePropertySteps;
call gds.beta.pipeline.linkPrediction.addNodeProperty('CrimeVictimPipeline','alpha.scaleProperties',{nodeProperties:['degree'], mutateProperty:'scaledDegree',scaler: 'MinMax'}) yield nodePropertySteps

CALL gds.beta.pipeline.linkPrediction.addFeature('CrimeVictimPipeline', 'hadamard', {
  nodeProperties: ['embedding']
}) YIELD featureSteps
CALL gds.beta.pipeline.linkPrediction.addFeature('CrimeVictimPipeline', 'hadamard', {
  nodeProperties: ['scaledDegree']
}) YIELD featureSteps
CALL gds.beta.pipeline.linkPrediction.configureSplit('CrimeVictimPipeline', {
  testFraction: 0.1,
  trainFraction: 0.1,
  validationFolds: 3
})
YIELD splitConfig;
CALL gds.beta.pipeline.linkPrediction.addLogisticRegression('CrimeVictimPipeline')
YIELD parameterSpace;

CALL gds.beta.pipeline.linkPrediction.train('LinkPred_Crime_Victm', {
  pipeline: 'CrimeVictimPipeline',
  modelName: 'lp-pipeline-model',
  metrics: ['AUCPR', 'OUT_OF_BAG_ERROR'],
  targetRelationshipType: 'Committed_against',
  randomSeed: 12
}) YIELD modelInfo, modelSelectionStats
RETURN
  modelInfo.bestParameters AS winningModel,
  modelInfo.metrics.AUCPR.train.avg AS avgTrainScore,
  modelInfo.metrics.AUCPR.outerTrain AS outerTrainScore,
  modelInfo.metrics.AUCPR.test AS testScore,
  [cand IN modelSelectionStats.modelCandidates | cand.metrics.AUCPR.validation.avg] AS validationScores

CALL gds.beta.pipeline.linkPrediction.predict.mutate('LinkPred_Crime_Victm',{
    modelName: 'lp-pipeline-model',
    mutateRelationshipType: 'Predict_Commited_Against',
    topN: 40,
    threshold: 0.45
}) YIELD  relationshipsWritten, samplingStats;


