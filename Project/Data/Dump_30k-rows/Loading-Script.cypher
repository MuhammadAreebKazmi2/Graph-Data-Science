:param {
  // Define the file path root and the individual file names required for loading.
  // https://neo4j.com/docs/operations-manual/current/configuration/file-locations/
  file_path_root: 'file:///', // Change this to the folder your script can access the files at.
  file_0: 'Crime_Data_from_2020_to_Present.csv'
};

// CONSTRAINT creation
// -------------------
//
// Create node uniqueness constraints, ensuring no duplicates for the given node label and ID property exist in the database. This also ensures no duplicates are introduced in future.
//
// NOTE: The following constraint creation syntax is generated based on the current connected database version 5.19-aura.
CREATE CONSTRAINT `DR_NO_Case_uniq` IF NOT EXISTS
FOR (n: `Case`)
REQUIRE (n.`DR_NO`) IS UNIQUE;
CREATE CONSTRAINT `Victim_id_Victim_uniq` IF NOT EXISTS
FOR (n: `Victim`)
REQUIRE (n.`Victim_id`) IS UNIQUE;
CREATE CONSTRAINT `Premis_Cd_Premise_uniq` IF NOT EXISTS
FOR (n: `Premise`)
REQUIRE (n.`Premis Cd`) IS UNIQUE;
CREATE CONSTRAINT `Weapon_Used Cd_Weapon_uniq` IF NOT EXISTS
FOR (n: `Weapon`)
REQUIRE (n.`Weapon Used Cd`) IS UNIQUE;
CREATE CONSTRAINT `Location_id_Location_uniq` IF NOT EXISTS
FOR (n: `Location`)
REQUIRE (n.`Location_id`) IS UNIQUE;
CREATE CONSTRAINT `Rpt_Dist No_District_uniq` IF NOT EXISTS
FOR (n: `District`)
REQUIRE (n.`Rpt Dist No`) IS UNIQUE;
CREATE CONSTRAINT `AREA_Area_uniq` IF NOT EXISTS
FOR (n: `Area`)
REQUIRE (n.`AREA`) IS UNIQUE;
CREATE CONSTRAINT `Crm_Cd_Crime_uniq` IF NOT EXISTS
FOR (n: `Crime`)
REQUIRE (n.`Crm Cd`) IS UNIQUE;

:param {
  idsToSkip: []
};

// NODE load
// ---------
//
// Load nodes in batches, one node label at a time. Nodes will be created using a MERGE statement to ensure a node with the same label and ID property remains unique. Pre-existing nodes found by a MERGE statement will have their other properties set to the latest values encountered in a load file.
//
// NOTE: Any nodes with IDs in the 'idsToSkip' list parameter will not be loaded.
LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.`DR_NO` IN $idsToSkip AND NOT toInteger(trim(row.`DR_NO`)) IS NULL
CALL {
  WITH row
  MERGE (n: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  SET n.`DR_NO` = toInteger(trim(row.`DR_NO`))
  SET n.`Date Rptd` = row.`Date Rptd`
  SET n.`DATE OCC` = row.`DATE OCC`
  SET n.`TIME OCC` = toInteger(trim(row.`TIME OCC`))
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.`Victim_id` IN $idsToSkip AND NOT toInteger(trim(row.`Victim_id`)) IS NULL
CALL {
  WITH row
  MERGE (n: `Victim` { `Victim_id`: toInteger(trim(row.`Victim_id`)) })
  SET n.`Victim_id` = toInteger(trim(row.`Victim_id`))
  SET n.`Vict Age` = toInteger(trim(row.`Vict Age`))
  SET n.`Vict Sex` = row.`Vict Sex`
  SET n.`Vict Descent` = row.`Vict Descent`
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.`Premis Cd` IN $idsToSkip AND NOT toInteger(trim(row.`Premis Cd`)) IS NULL
CALL {
  WITH row
  MERGE (n: `Premise` { `Premis Cd`: toInteger(trim(row.`Premis Cd`)) })
  SET n.`Premis Cd` = toInteger(trim(row.`Premis Cd`))
  SET n.`Premis Desc` = row.`Premis Desc`
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.`Weapon Used Cd` IN $idsToSkip AND NOT toInteger(trim(row.`Weapon Used Cd`)) IS NULL
CALL {
  WITH row
  MERGE (n: `Weapon` { `Weapon Used Cd`: toInteger(trim(row.`Weapon Used Cd`)) })
  SET n.`Weapon Used Cd` = toInteger(trim(row.`Weapon Used Cd`))
  SET n.`Weapon Desc` = row.`Weapon Desc`
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.`Location_id` IN $idsToSkip AND NOT toInteger(trim(row.`Location_id`)) IS NULL
CALL {
  WITH row
  MERGE (n: `Location` { `Location_id`: toInteger(trim(row.`Location_id`)) })
  SET n.`Location_id` = toInteger(trim(row.`Location_id`))
  SET n.`LOCATION` = row.`LOCATION`
  SET n.`LON` = toFloat(trim(row.`LON`))
  SET n.`LAT` = toFloat(trim(row.`LAT`))
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.`Rpt Dist No` IN $idsToSkip AND NOT toInteger(trim(row.`Rpt Dist No`)) IS NULL
CALL {
  WITH row
  MERGE (n: `District` { `Rpt Dist No`: toInteger(trim(row.`Rpt Dist No`)) })
  SET n.`Rpt Dist No` = toInteger(trim(row.`Rpt Dist No`))
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.`AREA` IN $idsToSkip AND NOT toInteger(trim(row.`AREA`)) IS NULL
CALL {
  WITH row
  MERGE (n: `Area` { `AREA`: toInteger(trim(row.`AREA`)) })
  SET n.`AREA` = toInteger(trim(row.`AREA`))
  SET n.`AREA NAME` = row.`AREA NAME`
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.`Crm Cd` IN $idsToSkip AND NOT toInteger(trim(row.`Crm Cd`)) IS NULL
CALL {
  WITH row
  MERGE (n: `Crime` { `Crm Cd`: toInteger(trim(row.`Crm Cd`)) })
  SET n.`Crm Cd` = toInteger(trim(row.`Crm Cd`))
  SET n.`Crm Cd Desc` = row.`Crm Cd Desc`
} IN TRANSACTIONS OF 10000 ROWS;


// RELATIONSHIP load
// -----------------
//
// Load relationships in batches, one relationship type at a time. Relationships are created using a MERGE statement, meaning only one relationship of a given type will ever be created between a pair of nodes.
LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  MATCH (target: `Area` { `AREA`: toInteger(trim(row.`AREA`)) })
  MERGE (source)-[r: `Occurs_in`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  MATCH (target: `Location` { `Location_id`: toInteger(trim(row.`Location_id`)) })
  MERGE (source)-[r: `Occurs_at`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Location` { `Location_id`: toInteger(trim(row.`Location_id`)) })
  MATCH (target: `Area` { `AREA`: toInteger(trim(row.`AREA`)) })
  MERGE (source)-[r: `Located_in`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Location` { `Location_id`: toInteger(trim(row.`Location_id`)) })
  MATCH (target: `District` { `Rpt Dist No`: toInteger(trim(row.`Rpt Dist No`)) })
  MERGE (source)-[r: `Belongs_to`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `District` { `Rpt Dist No`: toInteger(trim(row.`Rpt Dist No`)) })
  MATCH (target: `Location` { `Location_id`: toInteger(trim(row.`Location_id`)) })
  MERGE (source)-[r: `Includes`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Area` { `AREA`: toInteger(trim(row.`AREA`)) })
  MATCH (target: `District` { `Rpt Dist No`: toInteger(trim(row.`Rpt Dist No`)) })
  MERGE (source)-[r: `Contains`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  MATCH (target: `District` { `Rpt Dist No`: toInteger(trim(row.`Rpt Dist No`)) })
  MERGE (source)-[r: `Reported_in`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Victim` { `Victim_id`: toInteger(trim(row.`Victim_id`)) })
  MATCH (target: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  MERGE (source)-[r: `Reports`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  MATCH (target: `Victim` { `Victim_id`: toInteger(trim(row.`Victim_id`)) })
  MERGE (source)-[r: `Reported_by`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Weapon` { `Weapon Used Cd`: toInteger(trim(row.`Weapon Used Cd`)) })
  MATCH (target: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  MERGE (source)-[r: `Used_in`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  MATCH (target: `Weapon` { `Weapon Used Cd`: toInteger(trim(row.`Weapon Used Cd`)) })
  MERGE (source)-[r: `Committed_by`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  MATCH (target: `Premise` { `Premis Cd`: toInteger(trim(row.`Premis Cd`)) })
  MERGE (source)-[r: `Involves_premise`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Case` { `DR_NO`: toInteger(trim(row.`DR_NO`)) })
  MATCH (target: `Crime` { `Crm Cd`: toInteger(trim(row.`Crm Cd`)) })
  MERGE (source)-[r: `Type`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Victim` { `Victim_id`: toInteger(trim(row.`Victim_id`)) })
  MATCH (target: `Crime` { `Crm Cd`: toInteger(trim(row.`Crm Cd`)) })
  MERGE (source)-[r: `Affected_by`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Crime` { `Crm Cd`: toInteger(trim(row.`Crm Cd`)) })
  MATCH (target: `Victim` { `Victim_id`: toInteger(trim(row.`Victim_id`)) })
  MERGE (source)-[r: `Committed_against`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Weapon` { `Weapon Used Cd`: toInteger(trim(row.`Weapon Used Cd`)) })
  MATCH (target: `Victim` { `Victim_id`: toInteger(trim(row.`Victim_id`)) })
  MERGE (source)-[r: `Used_against`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Victim` { `Victim_id`: toInteger(trim(row.`Victim_id`)) })
  MATCH (target: `Weapon` { `Weapon Used Cd`: toInteger(trim(row.`Weapon Used Cd`)) })
  MERGE (source)-[r: `Offended_by`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Crime` { `Crm Cd`: toInteger(trim(row.`Crm Cd`)) })
  MATCH (target: `Area` { `AREA`: toInteger(trim(row.`AREA`)) })
  MERGE (source)-[r: `Took_place_in`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Crime` { `Crm Cd`: toInteger(trim(row.`Crm Cd`)) })
  MATCH (target: `Location` { `Location_id`: toInteger(trim(row.`Location_id`)) })
  MERGE (source)-[r: `Took_place_at`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row 
CALL {
  WITH row
  MATCH (source: `Crime` { `Crm Cd`: toInteger(trim(row.`Crm Cd`)) })
  MATCH (target: `Weapon` { `Weapon Used Cd`: toInteger(trim(row.`Weapon Used Cd`)) })
  MERGE (source)-[r: `Involves_weapon`]->(target)
} IN TRANSACTIONS OF 10000 ROWS;
