// Following are the questions the queries can answer.
// 1) Which district has the most number of cases reported.
// 2) Which Crime has the most number of cases reported in Los Angeles.
// 3) At what time is has the most number of cases occured in Los Angeles.
// 4) At what date has the most cases occured in Los Angeles?
// 5) At what date has the most cases reported in Los Angeles?
// 6) At what date has the most cases reported in Los Angeles on the day most cases occcured?
// 7) What are the top 10 crimes that have the most cases registered?
// 8) The hotbed district of cases has what type of crimes registered? (
This query identifies the district with the most cases reported and then finds the most frequent crime type (crime with the highest count) in that district, returning the district number, crime code, crime description, and number of cases for that crime type.)
// 9) What gender is most affected by the crimes in the hotbed?
// 10) What descent is most affected by the crimes in the hotbed?
// 11) What age/average is most affected by the crimes in the hotbed?
// 12) What is the weapon used in most cases in Los Angeles?
// ** 13) ** What weapon is used in most cases in the hotbed district?
// ** 14) **What weapon is used against people of the vulnerable descent in the hotbed district?
// 15) Where did the most cases took place precisely (location based)?
// 16) Where did the most cases occur in what area?
// ** 17) **The type of crimes most recurrent at those streets
// 18) The premise type of those places of most cases reported at the hotbed location?
// 19) The premise type where most cases reported in Los Angeles?
// ** 20) **Any queries that could use of the triangle property and queries.
// ** 21) **What crimes at what premis and the use of what weapons is the most common in an area/district?
// ** 22) ** What crimes at what premis and the use of what weapons is the most common in an against a gender/ethnic group?
// 23) Which crime is mostly committed against victims of one descent?
// 24) Which crime is mostly committed against victims of one age?
// 25) Which weapon is mostly used against victims of one age in Los Angeles?
// 26) Which weapon is mostly used against victims of one descent in Los Angeles?
// ** 27) What crimes reported in the hotbed district happened on the same date?
// ** 28) What was the average delay for the cases to be reported in the hotbed district?


// ************************* Q1 **************************************
// Step 1: Calculate the maximum number of cases reported in a district
MATCH (c:Case)-[:Reported_in]->(d:District)
WITH d, count(c) AS caseCount
// Store the maximum number of cases in a separate variable
//RETURN max(caseCount) AS maxCases

// Step 2: Match cases to districts again and use the maximum case count
WITH max(caseCount) AS maxCases
MATCH (c:Case)-[:Reported_in]->(d:District)
WITH d, count(c) AS caseCount, maxCases
WHERE caseCount = maxCases
RETURN d.`Rpt Dist No` AS District, caseCount AS NumberOfCases;
// ************************* end of Q1 **************************************
// District: 162 (Cases: 282)


// // ************************* Q2 **************************************
// Step 1: Calculate the maximum number of cases reported for any crime
MATCH (c:Case)-[:Type]->(crime:Crime)
WITH crime, count(c) AS caseCount

// Step 2: Find all crimes that have the maximum number of cases reported
WITH MAX(caseCount) AS maxCases
MATCH (c:Case)-[:Type]->(crime:Crime)
WITH crime, count(c) AS caseCount, maxCases
WHERE caseCount = maxCases
RETURN crime.`Crm Cd` AS CrimeCode, crime.`Crm Cd Desc` AS CrimeDescription, caseCount AS NumberOfCases;
// ************************* end of Q2 **************************************
// 331 "THEFT FROM MOTOR VEHICLE - GRAND ($950.01 AND OVER)" : NumberOfCases: 4776


// // *************************** Q3 ****************************************
// Step 1: Calculate the maximum number of cases occurring at any time of day
MATCH (c:Case)
WITH c.`TIME OCC` AS timeOcc, count(c) AS caseCount

// Step 2: Find all times of day that have the maximum number of cases occurring
WITH max(caseCount) AS maxCases
MATCH (c:Case)
WITH c.`TIME OCC` AS timeOcc, count(c) AS caseCount, maxCases
WHERE caseCount = maxCases
RETURN timeOcc AS TimeOfOccurrence, caseCount AS NumberOfCases
ORDER BY TimeOfOccurrence;
// ************************* end of Q3 **************************************
// Time: 12:00    ||   NumberOfCases: 1186

// // *************************** Q4 ****************************************
// Step 1: Calculate the maximum number of cases occurring on any date
MATCH (c:Case)
WITH c.`DATE OCC` AS dateOcc, count(c) AS caseCount
WITH max(caseCount) AS maxCases
MATCH (c:Case)
WITH c.`DATE OCC` AS dateOcc, count(c) AS caseCount, maxCases
WHERE caseCount = maxCases
RETURN dateOcc AS DateOfOccurrence, caseCount AS NumberOfCases
ORDER BY DateOfOccurrence;
// ************************* end of Q4 **************************************
// DateOfOccurrence: "1/1/2020 0:00" || NumberOfCases: 312


// // *************************** Q5 ****************************************
// Step 1: Calculate the maximum number of cases reported on any date
MATCH (c:Case)
WITH c.`Date Rptd` AS dateReported, count(c) AS caseCount
WITH max(caseCount) AS maxCasesReported

MATCH (c:Case)
WITH c.`Date Rptd` AS dateReported, count(c) AS caseCount, maxCasesReported
WHERE caseCount = maxCasesReported
RETURN dateReported AS DateReported, caseCount AS NumberOfCases
ORDER BY DateReported;
// ************************* end of Q5 **************************************
// DateReported: "1/16/2020 0:00" || NumberOfCases: 195


// // *************************** Q6 ****************************************
// Step 1: Calculate the maximum number of cases reported for cases occurring on "1/1/2020 0:00"
MATCH (c:Case)
WHERE c.`DATE OCC` = "1/1/2020 0:00"
WITH c.`Date Rptd` AS dateReported, count(c) AS caseCount
WITH max(caseCount) AS maxCases

// Step 2: Find all dates that have the maximum number of cases reported and return the date along with the count
MATCH (c:Case)
WHERE c.`DATE OCC` = "1/1/2020 0:00"
WITH c.`Date Rptd` AS dateReported, count(c) AS caseCount, maxCases
WHERE caseCount = maxCases
RETURN dateReported AS DateReported, caseCount AS NumberOfCases
ORDER BY DateReported;
// ************************* end of Q6 **************************************
// DateReported: "1/1/2020 0:00" || NumberOfCases: 107

// // *************************** Q7 ****************************************
MATCH (c:Case)-[:Type]->(crime:Crime)
WITH crime, count(c) AS caseCount
ORDER BY caseCount DESC
LIMIT 10
RETURN crime.`Crm Cd` AS CrimeCode, crime.`Crm Cd Desc` AS CrimeDescription, caseCount AS NumberOfCases;
// ************************* end of Q7 **************************************


// // *************************** Q8 ****************************************
MATCH (c:Case)-[:Reported_in]->(d:District)
WITH d, count(c) AS caseCount
// Store the maximum number of cases in a separate variable
//RETURN max(caseCount) AS maxCases

// Step 2: Match cases to districts again and use the maximum case count
WITH max(caseCount) AS maxCases
MATCH (c:Case)-[:Reported_in]->(d:District)
WITH d, count(c) AS caseCount, maxCases
WHERE caseCount = maxCases
WITH d.`Rpt Dist No` AS District, caseCount AS NumberOfCases, d

MATCH (c:Case)-[:Reported_in]->(d), (c)-[:Type]->(crime:Crime)
where d.`Rpt Dist No` = District
WITH crime, count(c) AS crimeCount, d AS districtWithMostCases
// Order by the crime count to find the top crime type
ORDER BY crimeCount DESC
// Return the top crime type in the district with the most cases reported
RETURN districtWithMostCases.`Rpt Dist No` AS DistrictNumber, crime.`Crm Cd` AS CrimeCode, crime.`Crm Cd Desc` AS CrimeDescription, crimeCount AS NumberOfCases;
// ************************* end of Q8 **************************************
// 162 ||442 || "SHOPLIFTING - PETTY THEFT ($950 & UNDER)" || Cases: 71
// 162 || 330 || "BURGLARY FROM VEHICLE" || NumberOfCases: 25


// // *************************** Q9 ****************************************
// Step 1: Find the district with the most cases reported and calculate the maximum case count
MATCH (c:Case)-[:Reported_in]->(d:District)
WITH d, count(c) AS caseCount
// Calculate the maximum number of cases reported in any district
WITH max(caseCount) AS maxCases
MATCH (c:Case)-[:Reported_in]->(d:District)
WITH d, count(c) AS caseCount, maxCases
// Filter to find the district with the maximum cases reported
WHERE caseCount = maxCases
WITH d.`Rpt Dist No` AS DistrictNumber, d AS districtWithMostCases


// Step 2: Match cases in the district with the most cases reported to victims and group by sex
MATCH (c:Case)-[:Reported_in]->(districtWithMostCases), (c)-[:Reported_by]->(v:Victim)
WITH v.`Vict Sex` AS victimSex, count(c) AS caseCount
// Order the results by case count in descending order
ORDER BY caseCount DESC
// Return the sex of victims and the number of cases they were affected by
RETURN victimSex AS VictimSex, caseCount AS NumberOfCases;
// ************************* end of Q9 **************************************
// M || NumberOfCases: 163


// // *************************** Q10 ****************************************
// Step 1: Find the district with the most cases reported and calculate the maximum case count
MATCH (c:Case)-[:Reported_in]->(d:District)
WITH d, count(c) AS caseCount
// Calculate the maximum number of cases reported in any district
WITH max(caseCount) AS maxCases
MATCH (c:Case)-[:Reported_in]->(d:District)
WITH d, count(c) AS caseCount, maxCases
// Filter to find the district with the maximum cases reported
WHERE caseCount = maxCases
WITH d.`Rpt Dist No` AS DistrictNumber, d AS districtWithMostCases

// Step 2: Match cases in the district with the most cases reported to victims and group by descent
MATCH (c:Case)-[:Reported_in]->(districtWithMostCases), (c)-[:Reported_by]->(v:Victim)
WITH v.`Vict Descent` AS victimDescent, count(c) AS caseCount
// Order the results by case count in descending order
ORDER BY caseCount DESC
// Return the descent of victims and the number of cases they were affected by
RETURN victimDescent AS VictimDescent, caseCount AS NumberOfCases;
// ************************* end of Q10 **************************************
// H || 73
// W || 65 
// B || 53... 

// // *************************** Q11 ****************************************
// Step 1: Calculate the maximum number of cases reported in any district and find the district with the maximum cases reported
MATCH (c:Case)-[:Reported_in]->(d:District)
WITH d, count(c) AS caseCount
WITH d, caseCount, max(caseCount) AS maxCases
// Filter to find the district(s) with the maximum number of cases reported
WHERE caseCount = maxCases
WITH d AS districtWithMostCases

// Step 2: Calculate the average age of victims affected by crimes in the district with the most cases reported
MATCH (c:Case)-[:Reported_in]->(districtWithMostCases), (c)-[:Reported_by]->(v:Victim)
WITH v.`Vict Age` AS victimAge
RETURN avg(victimAge) AS AverageVictimAge;
// ************************* end of Q11 **************************************


// // *************************** Q12 ****************************************
// Step 1: Calculate the maximum number of cases in which any weapon was used
MATCH (c:Case)-[:Committed_by]->(w:Weapon)
WITH w.`Weapon Used Cd` AS weaponCode, w.`Weapon Desc` AS weaponDescription, count(c) AS caseCount
WITH max(caseCount) AS maxCases

// Step 2: Find the weapon(s) used in the maximum number of cases
MATCH (c:Case)-[:Committed_by]->(w:Weapon)
WITH w.`Weapon Used Cd` AS weaponCode, w.`Weapon Desc` AS weaponDescription, count(c) AS caseCount, maxCases
WHERE caseCount = maxCases
// Return the weapon code, weapon description, and the number of cases
RETURN weaponCode AS WeaponCode, weaponDescription AS WeaponDescription, caseCount AS NumberOfCases;
// ************************* end of Q12 **************************************
// Weapon Cd: 400 || weaponDescription: "STRONG-ARM (HANDS, FIST, FEET OR BODILY FORCE)" || NumberOfCases: 4524 

// // *************************** Q13 ****************************************
// ************************* end of Q13 **************************************


// // *************************** Q14 **************************************
// ************************* end of Q14 **************************************


// // *************************** Q15 ****************************************
// Step 1: Calculate the maximum number of cases at any location
MATCH (c:Case)-[:Occurs_at]->(l:Location)
WITH l.`Location_id` AS locationID, count(c) AS caseCount
// Calculate the maximum case count at any location
WITH max(caseCount) AS maxCases

// Step 2: Find the location(s) with the maximum number of cases and return the details
MATCH (c:Case)-[:Occurs_at]->(l:Location)
WITH l.`Location_id` AS locationID, l.`LOCATION` AS locationDescription, l.`LAT` AS latitude, l.`LON` AS longitude, count(c) AS caseCount, maxCases
// Filter to include only locations with the maximum number of cases
WHERE caseCount = maxCases
// Return the location details and number of cases
RETURN locationID AS LocationID, locationDescription AS LocationDescription, latitude AS Latitude, longitude AS Longitude, caseCount AS NumberOfCases;
// ************************* end of Q15 **************************************
// Loc ID: 6180 || LocationDescription: "700 S  HOPE                         ST" || NumberOfCases: 80


// // *************************** Q16 ****************************************
// Step 1: Calculate the maximum number of cases in any area
MATCH (c:Case)-[:Occurs_in]->(a:Area)
WITH a.`AREA` AS areaCode, a.`AREA NAME` AS areaName, count(c) AS caseCount
// Calculate the maximum case count in any area
WITH max(caseCount) AS maxCases

// Step 2: Find the area with the maximum number of cases
MATCH (c:Case)-[:Occurs_in]->(a:Area)
WITH a.`AREA` AS areaCode, a.`AREA NAME` AS areaName, count(c) AS caseCount, maxCases
// Filter to include only the area with the maximum number of cases
WHERE caseCount = maxCases
// Return the area code, area name, and the number of cases
RETURN areaCode AS AreaCode, areaName AS AreaName, caseCount AS NumberOfCases;
// ************************* end of Q16 **************************************
// 

// // *************************** Q17 **************************************
// ************************* end of Q17 **************************************


// // *************************** Q18 ****************************************
// Step 1: Calculate the maximum number of cases at any location
MATCH (c:Case)-[:Occurs_at]->(l:Location)
WITH l.`Location_id` AS locationID, count(c) AS caseCount
WITH max(caseCount) AS maxCases

// Step 2: Find the locations with the maximum number of cases
MATCH (c:Case)-[:Occurs_at]->(l:Location)
WITH l.`Location_id` AS locationID, l, count(c) AS caseCount, maxCases
WHERE caseCount = maxCases

// Step 3: Find the most common premise type at those locations
MATCH (c:Case)-[:Occurs_at]->(l), (c)-[:Involves_premise]->(p:Premise)
WITH p.`Premis Cd` AS premiseCode, p.`Premis Desc` AS premiseDescription, count(c) AS premiseCount
// Group by premise code and description, and count the number of cases
WITH premiseCode, premiseDescription, premiseCount
// Order by premise count in descending order
ORDER BY premiseCount DESC
LIMIT 1
// Return the premise code, premise description, and the number of cases
RETURN premiseCode AS PremiseCode, premiseDescription AS PremiseDescription, premiseCount AS NumberOfCases;
// ************************* end of Q18 **************************************
PremiseCode: 404 || PremiseDescription: "Dept Store" || NumberOfCases: 56


// // *************************** Q19 ****************************************
// Step 1: Calculate the maximum number of cases reported at any premise type
MATCH (c:Case)-[:Involves_premise]->(p:Premise)
WITH p.`Premis Cd` AS premiseCode, p.`Premis Desc` AS premiseDescription, count(c) AS caseCount
// Calculate the maximum case count reported at any premise
WITH max(caseCount) AS maxCases

// Step 2: Find the premise type with the maximum number of cases reported
MATCH (c:Case)-[:Involves_premise]->(p:Premise)
WITH p.`Premis Cd` AS premiseCode, p.`Premis Desc` AS premiseDescription, count(c) AS caseCount, maxCases
// Filter to include only the premise types with the maximum number of cases reported
WHERE caseCount = maxCases
// Return the premise code, premise description, and the number of cases reported
RETURN premiseCode AS PremiseCode, premiseDescription AS PremiseDescription, caseCount AS NumberOfCases;
// ************************* end of Q19 **************************************
// PremiseCode: 101 || PremiseDescription: "Street" || NumberOfCasesL 9050


// // *************************** Q20 **************************************
// ************************* end of Q20 **************************************


// // *************************** Q21 **************************************
// ************************* end of Q21 **************************************


// // *************************** Q22 **************************************
// ************************* end of Q22 **************************************


// // *************************** Q23 ****************************************
// Step 1: Calculate the most common crime type committed against victims of each descent
MATCH (c:Case)-[:Reported_by]->(v:Victim), (c)-[:Type]->(crime:Crime)
WITH v.`Vict Descent` AS victimDescent, crime.`Crm Cd` AS crimeCode, crime.`Crm Cd Desc` AS crimeDescription, count(c) AS crimeCount
// Group cases by victim descent, crime type, and count the number of cases for each
WITH victimDescent, crimeCode, crimeDescription, crimeCount
// Calculate the maximum crime count for each victim descent
WITH victimDescent, max(crimeCount) AS maxCrimeCount
// Filter the results to include only the most common crime type for each descent
MATCH (c:Case)-[:Reported_by]->(v:Victim), (c)-[:Type]->(crime:Crime)
WHERE v.`Vict Descent` = victimDescent
WITH victimDescent, crime.`Crm Cd` AS crimeCode, crime.`Crm Cd Desc` AS crimeDescription, count(c) AS crimeCount, maxCrimeCount
WHERE crimeCount = maxCrimeCount
// Return the victim descent, crime code, crime description, and the number of cases
RETURN victimDescent AS VictimDescent, crimeCode AS CrimeCode, crimeDescription AS CrimeDescription, crimeCount AS NumberOfCases
ORDER BY NumberOfCases DESC
// ************************* end of Q23 **************************************
// W || 331 || "THEFT FROM MOTOR VEHICLE - GRAND ($950.01 AND OVER)" || NumberOfCases: 1905

// // *************************** Q24 ****************************************
// Step 1: Calculate the most frequent crime type committed against victims of each age
MATCH (c:Case)-[:Reported_by]->(v:Victim), (c)-[:Type]->(crime:Crime)
WITH v.`Vict Age` AS victimAge, crime.`Crm Cd` AS crimeCode, crime.`Crm Cd Desc` AS crimeDescription, count(c) AS crimeCount
// Group cases by victim age, crime type, and count the number of cases for each
WITH victimAge, crimeCode, crimeDescription, crimeCount
// Calculate the maximum crime count for each victim age
WITH victimAge, max(crimeCount) AS maxCrimeCount
// Filter the results to include only the most common crime type for each age
MATCH (c:Case)-[:Reported_by]->(v:Victim), (c)-[:Type]->(crime:Crime)
WHERE v.`Vict Age` = victimAge
WITH victimAge, crime.`Crm Cd` AS crimeCode, crime.`Crm Cd Desc` AS crimeDescription, count(c) AS crimeCount, maxCrimeCount
WHERE crimeCount = maxCrimeCount
// Return the victim age, crime code, crime description, and the number of cases
RETURN victimAge AS VictimAge, crimeCode AS CrimeCode, crimeDescription AS CrimeDescription, crimeCount AS NumberOfCases;
// ************************* end of Q24 **************************************
// 36 || 331 || "THEFT FROM MOTOR VEHICLE - GRAND ($950.01 AND OVER)" || NumberOfCases: 143

// // *************************** Q25 ***************************************
// Step 1: Calculate the most frequently used weapon against victims of each age
MATCH (c:Case)-[:Reported_by]->(v:Victim), (c)-[:Committed_by]->(w:Weapon)
WITH v.`Vict Age` AS victimAge, w.`Weapon Used Cd` AS weaponCode, w.`Weapon Desc` AS weaponDescription, count(c) AS weaponCount
// Group cases by victim age and weapon, and count the number of cases for each
WITH victimAge, weaponCode, weaponDescription, weaponCount
// Calculate the maximum weapon count for each victim age
WITH victimAge, max(weaponCount) AS maxWeaponCount
// Filter the results to include only the most commonly used weapon for each age
MATCH (c:Case)-[:Reported_by]->(v:Victim), (c)-[:Committed_by]->(w:Weapon)
WHERE v.`Vict Age` = victimAge
WITH victimAge, w.`Weapon Used Cd` AS weaponCode, w.`Weapon Desc` AS weaponDescription, count(c) AS weaponCount, maxWeaponCount
WHERE weaponCount = maxWeaponCount
// Return the victim age, weapon code, weapon description, and the number of cases
RETURN victimAge AS VictimAge, weaponCode AS WeaponCode, weaponDescription AS WeaponDescription, weaponCount AS NumberOfCases
ORDER BY NumberOfCases DESC
// ************************* end of Q25 **************************************
// 30 | 400 || "STRONG-ARM (HANDS, FIST, FEET OR BODILY FORCE)" || NumberOfCases: 134


// // *************************** Q26 ****************************************
// Step 1: Calculate the most frequent weapon used against victims of each descent
MATCH (c:Case)-[:Reported_by]->(v:Victim), (c)-[:Committed_by]->(w:Weapon)
WITH v.`Vict Descent` AS victimDescent, w.`Weapon Used Cd` AS weaponCode, w.`Weapon Desc` AS weaponDescription, count(c) AS weaponCount
// Group cases by victim descent, weapon, and count the number of cases for each
WITH victimDescent, weaponCode, weaponDescription, weaponCount
// Calculate the maximum weapon count for each victim descent
WITH victimDescent, max(weaponCount) AS maxWeaponCount
// Filter the results to include only the most commonly used weapon for each descent
MATCH (c:Case)-[:Reported_by]->(v:Victim), (c)-[:Committed_by]->(w:Weapon)
WHERE v.`Vict Descent` = victimDescent
WITH victimDescent, w.`Weapon Used Cd` AS weaponCode, w.`Weapon Desc` AS weaponDescription, count(c) AS weaponCount, maxWeaponCount
WHERE weaponCount = maxWeaponCount
// Return the victim descent, weapon code, weapon description, and the number of cases
RETURN victimDescent AS VictimDescent, weaponCode AS WeaponCode, weaponDescription AS WeaponDescription, weaponCount AS NumberOfCases
ORDER BY NumberOfCases DESC
// ************************* end of Q26 **************************************
// H || 400 || "STRONG-ARM (HANDS, FIST, FEET OR BODILY FORCE)" || NumberOfCases: 2154

// // *************************** Q27 ****************************************
// // *************************** Q27 ****************************************


// // *************************** Q28 ****************************************
// // *************************** Q28 ****************************************


// // *************************** Q29 ****************************************
// // *************************** Q29 ****************************************


//
//
//