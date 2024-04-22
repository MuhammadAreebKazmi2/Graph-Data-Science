// Define parameters
:param {
  file_path_root: 'file:///', 
  file_0: 'Crime_Data_from_2020_to_Present.csv',
  idsToSkip: []
};

// CONSTRAINT creation
// -------------------
//
// Create node uniqueness constraints to ensure that no duplicates exist for each node label and ID property.
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Crime) REQUIRE n.CrmCd IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Premis) REQUIRE n.Premise_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Weapon) REQUIRE n.Weapon_Used_Cd IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Location) REQUIRE n.Location_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Victim) REQUIRE n.Victim_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:District) REQUIRE n.Rpt_Dist_No IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Area) REQUIRE n.AREA IS UNIQUE;

// NODE load
// ---------
//
// Load nodes in batches from the CSV file
LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.'Crm Cd 1' IN $idsToSkip AND NOT toInteger(trim(row.'Crm Cd 1')) IS NULL
CALL {
    WITH row
    MERGE (n:Crime {CrmCd: toInteger(trim(row.'Crm Cd 1'))})
    SET n.CrmCd = toInteger(trim(row.'Crm Cd 1'))
    SET n.DR_NO = toInteger(trim(row.'DR_NO'))
    SET n.DateRptd = row.'Date Rptd'
    SET n.DateOcc = row.'DATE OCC'
    SET n.CrmCdDesc = row.'Crm Cd Desc'
    SET n.TimeOcc = toInteger(trim(row.'TIME OCC'))
} IN TRANSACTIONS OF 10000 ROWS;

// (Continue for other node types, updating as shown above)
// 
// For example:
// Load Premis nodes from the CSV file
LOAD CSV WITH HEADERS FROM ($file_path_root + $file_0) AS row
WITH row
WHERE NOT row.'Premis Cd' IN $idsToSkip AND row['Premis Cd'] IS NOT NULL
CALL {
    WITH row
    MERGE (n:Premis {Premise_id: row['Premis Cd']})
    SET n.Premise_id = row['Premis Cd']
    SET n.PremisDesc = row['Premis Desc']
} IN TRANSACTIONS OF 10,000 ROWS;

// Load other nodes and relationships similarly
// Please use the same structure and format for other types of nodes and relationships.
