LOAD CSV WITH HEADERS FROM 'file:///Crime_Data_from_2020_to_Present.csv' AS row
WITH row
WHERE row.`Crm Cd` IS NOT NULL
MERGE (:Crime {crime_id: row.`Crm Cd 1`, crime_type: row.`Crm Cd Desc`})
MERGE (:Premise {premise_id: row.`Premis Cd`, premise_type: row.`Premis Desc`})
WITH row
WHERE row.`Weapon Used Cd` IS NOT NULL
MERGE (:Weapon {weapon_id: row.`Weapon Used Cd`, weapon_type: row.`Weapon Desc`})
MERGE (:Victim {victim_id: row.`DR_NO`, age: row.`Vict Age`, sex: row.`Vict Sex`, descent: row.`Vict Descent`})
MERGE (:Location {street: row.`LOCATION`, latitude: row.LAT, longitude: row.LON })
MERGE (:District {district_id: row.`Rpt Dist No`})
MERGE (:Area {area_id: row.AREA, area_name: row.`AREA NAME`})
