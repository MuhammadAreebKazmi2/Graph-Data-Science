LOAD CSV WITH HEADERS FROM 'file:///Crime_Data_from_2020_to_Present.csv' AS row
WITH row
WHERE row.`Crm Cd` IS NOT NULL
MERGE (c:Crime {crime_id: row.`Crm Cd`, crime_type: row.`Crm Cd Desc`})
MERGE (p:Premise {premise_id: row.`Premis Cd`, premise_type: row.`Premis Desc`})
WITH row
WHERE row.`Weapon Used Cd` IS NOT NULL
MERGE (w:Weapon {weapon_id: row.`Weapon Used Cd`, weapon_type: row.`Weapon Desc`})
MERGE (v:Victim {victim_id: row.`DR_NO`, age: row.`Vict Age`, sex: row.`Vict Sex`, descent: row.`Vict Descent`})
MERGE (l:Location {street: row.`LOCATION`, latitude: row.LAT, longitude: row.LON })
MERGE (d:District {district_id: row.`Rpt Dist No`})
MERGE (a:Area {area_id: row.AREA, area_name: row.`AREA NAME`})

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