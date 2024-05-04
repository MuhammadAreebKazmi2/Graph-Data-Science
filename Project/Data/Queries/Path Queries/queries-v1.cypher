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
// 9) What is the weapon used in most crimes/cases?
// 10) Where did the most cases took place precisely (location based)?
// 11) Where did the most cases took place at what street (street based)?
// 12) The type of crimes most recurrent at those streets
// 13) The premise type of those places of crime?
// 14) Any queries that could use of the triangle property and queries.
// 15) What crimes at what premis and the use of what weapons is the most common in an area/district?
// 16) What crimes at what premis and the use of what weapons is the most common in an against a gender/ethnic group?
// 17) Which crime is mostly committed against victims of one descent?
// 18) Which crime is mostly committed against victims of one age?
// 19) Which weapon is mostly used against victims of one age?
// 20) Which weapon is mostly used against victims of one descent?
// 21) What crimes reported in the hotbed district happened on the same date?
// 22) What was the average delay for the cases to be reported in the hotbed district?
// 23) What Area/neighborhood is the hotbed of crimes?


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


// // *************************** Q3 **************************************
// ************************* end of Q3 **************************************


// // *************************** Q3 **************************************
// ************************* end of Q3 **************************************


// // *************************** Q3 **************************************
// ************************* end of Q3 **************************************


// // *************************** Q3 **************************************
// ************************* end of Q3 **************************************


// // *************************** Q3 **************************************
// ************************* end of Q3 **************************************


// // *************************** Q3 **************************************
// ************************* end of Q3 **************************************


// // *************************** Q3 **************************************
// ************************* end of Q3 **************************************


// // *************************** Q3 **************************************
// ************************* end of Q3 **************************************


// // *************************** Q3 **************************************
// ************************* end of Q3 **************************************


//
//
//
//