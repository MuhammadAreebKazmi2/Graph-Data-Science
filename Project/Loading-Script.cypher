// Create node uniqueness constraints to ensure that no duplicates exist for each node label and ID property.
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Crime) REQUIRE n.CrmCd IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Premis) REQUIRE n.Premise_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Weapon) REQUIRE n.Weapon_Used_Cd IS UNIQUE;
//CREATE CONSTRAINT IF NOT EXISTS FOR (n:Location) REQUIRE n.Location_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Victim) REQUIRE n.Victim_id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:District) REQUIRE n.Rpt_Dist_No IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (n:Area) REQUIRE n.Area_id IS UNIQUE;

// Loading data nodes
LOAD CSV WITH HEADERS FROM 'file:///Crime_Data_from_2020_to_Present.csv' AS row
WITH row
WHERE row.`Crm Cd` IS NOT NULL
MERGE (c:Crime {Crmcd: toInteger(trim(row.`Crm Cd 1`)), CrmCdDesc: row.`Crm Cd Desc`, DR_NO: toInteger(trim(row.`DR_NO`)), DateRptd: row.`Date Rptd`, DateOcc: row.`DATE OCC`, TimeOcc: toInteger(trim(row.`TIME OCC`))})
MERGE (p:Premise {Premise_id: row.`Premis Cd`, PremisDesc: row.`Premis Desc`})
WITH row
WHERE row.`Weapon Used Cd` IS NOT NULL
MERGE (w:Weapon {Weapon_Used_Cd: toInteger(trim(row.`Weapon Used Cd`)), WeaponDesc: row.`Weapon Desc`})
MERGE (v:Victim {Victim_id: toInteger(trim(row.`Victim_id`)), age: toInteger(trim(row.`Vict Age`)), sex: row.`Vict Sex`, descent: row.`Vict Descent`})
MERGE (l:Location {street: row.`LOCATION`, latitude: toFloat(trim(row.`LAT`)), longitude: toFloat(trim(row.`LON`))})
MERGE (d:District {Rpt_Dist_No: toInteger(trim(row.`Rpt Dist No`))})
MERGE (a:Area {Area_id: toInteger(trim(row.`AREA`)), area_name: row.`AREA NAME`})

MERGE (c)-[:Occurs_in]->(a)
MERGE (c)-[:Occurs_at]->(l)
MERGE (l)-[:Located_In]->(a)
MERGE (l)-[:Belongs_To]->(d)
MERGE (d)-[:Includes]->(l)
MERGE (a)-[:Contains]->(d)
MERGE (c)-[:Reported_in]->(d)
MERGE (v)-[:Affected_By]->(c)
MERGE (c)-[:Committed_Against]->(v)
MERGE (w)-[:Used_In]->(c)
MERGE (c)-[:Committed_By]->(w)
MERGE (c)-[:Involves]->(p)