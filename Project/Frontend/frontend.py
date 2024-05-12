import tkinter.messagebox
from py2neo import Graph
import customtkinter as tk
graph = Graph("bolt://localhost:7687", auth=("neo4j", "123456789"))

def show_max_reported_case_by_area():
     #Which district has the most number of cases reported.
    query = """
    MATCH (c:Case)-[:Reported_in]->(d:District)
    WITH d, count(c) AS caseCount
    RETURN max(caseCount) AS maxCases
    """
    execute_query(query, "Max Reported Cases by area")

def central_hotspots_of_crimes():
    #page rank query
    query="""
    CALL gds.louvain.stream('caseAreaGraph', {})
    YIELD nodeId, communityId
    WITH nodeId, communityId, gds.util.asNode(nodeId) AS node
    WHERE node:Case  // Filter to only include Case nodes
    RETURN node.DR_NO AS Case_No, communityId
    ORDER BY communityId;

  """
    execute_query(query, "Central Crime Hotspots")

def crime_clusers():
#clusters of areas with similar crime characteristics. ---- community detection
    query=""" 

        CALL gds.pageRank.stream('crimeProjection', {
            maxIterations: 20, // You can adjust this value as needed
            dampingFactor: 0.85 // Damping factor commonly used for PageRank
        })
        YIELD nodeId, score
        MATCH (n:`Crime`) WHERE id(n) = nodeId
        RETURN n.`Crm Cd` AS crimeId, n.`Crm Cd Desc` AS crimeDescription, score
        ORDER BY score DESC
        LIMIT 10;""" 
    execute_query(query, "Crime Characterstic Clusters")


def top_ten_crimes():
    # top 10 crimes that have the most cases registered

    query="""
    MATCH (c:Case)-[:Type]->(crime:Crime)
    WITH crime, count(c) AS caseCount
    ORDER BY caseCount DESC
    LIMIT 10
    RETURN crime.`Crm Cd` AS CrimeCode, crime.`Crm Cd Desc` AS CrimeDescription, caseCount AS NumberOfCases;
    """
    execute_query(query, "Top 10 Crime Incidences")

def age_most_affected():
    #What age/average is most affected by the crimes in the hotbed?
    query= """
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
"""
    execute_query(query, "Most Affected Age Group")
def genders_most_affected():
    #What gender is most affected by the crimes in the hotbed?
    query="""
    
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
    """
    execute_query(query, "Most Affected Gender")

def most_cases_location_based():
# Where did the most cases took place precisely (location based)?
    query="""
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
        """
    execute_query(query, "Most Affected Location")
def crime_against_oneage_victm():
#)Which crime is mostly committed against victims of one age?

    query="""// Step 1: Calculate the most frequent crime type committed against victims of each age
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
    // ************************* end of Q24 **************************************""" 
    execute_query(query, "Crime by Age Targeting")
def link_prediction():
    query="""CALL gds.beta.pipeline.linkPrediction.predict.mutate('LinkPred_Crime_Victm',{
    mutateRelationshipType: 'Predict_Commited_Against',
    topN: 40,
    threshold: 0.45
}) YIELD  relationshipsWritten, samplingStats;"""
    execute_query(query, "link_prediction")
def Weapon_freq_victm():
    query="""
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
    """
    execute_query(query, "weapon_freq_descent")
def community_detection():
    query="""
        CALL gds.louvain.stream('caseAreaGraph', {})
        YIELD nodeId, communityId
        WITH nodeId, communityId, gds.util.asNode(nodeId) AS node
        WHERE node:Case  // Filter to only include Case nodes
        RETURN node.DR_NO AS Case_No, communityId
        ORDER BY communityId;

        MATCH (a:Area)<-[:Occurs_in]-(c:Case)
        WITH a.AREA AS area, count(c) AS caseCount
        RETURN area, caseCount
        ORDER BY caseCount DESC;

        // just confirmed that that the case lied in the area with most cases (2nd) and lied in the communityId
        MATCH (c:Case {DR_NO: 10304468})-[r]-(m)
        RETURN c, r, m"""
    execute_query(query, "community detection")

def execute_query(query, title):
    try:
        result = graph.run(query).data()
        if result:
            output = f"{title}:\n" + '\n'.join([f"{key}: {val}" for res in result for key, val in res.items()]) + "\n\n"
        else:
            output = f"{title}: No data found.\n\n"
        textbox.delete('1.0',tk.END)
        textbox.insert('1.0', output)
    except Exception as e:
        textbox.insert(tk.END, f"Error fetching {title.lower()}: {str(e)}\n\n")

tk.set_appearance_mode("Light")  # Modes: "System" (standard), "Dark", "Light"
tk.set_default_color_theme("green")  # Themes: "blue" (standard), "green", "dark-blue"

root = tk.CTk()

# configure window
root.title("Chikuu.py")
root.geometry(f"{1100}x{580}")

# configure grid layout (4x4)
root.grid_rowconfigure((0, 1, 2), weight=1)

# create sidebar frame with widgets
sidebar_frame = tk.CTkFrame(root, width=140, corner_radius=0)
sidebar_frame.grid(row=0, column=0, rowspan=4, sticky="nsew")
sidebar_frame.grid_rowconfigure(4, weight=1)
logo_label = tk.CTkLabel(sidebar_frame, text="Crime Data Analyzer", font=tk.CTkFont(size=20, weight="bold"))
logo_label.grid(row=0, column=0, padx=20, pady=(20, 10))

contributors_label = tk.CTkLabel(sidebar_frame, text="Contributors:", font=tk.CTkFont(weight="bold"))
contributors_label.grid(row=1, column=0, padx=0, pady=(50, 0))
sidra_label = tk.CTkLabel(sidebar_frame, text="Sidra Aamir")
sidra_label.grid(row=2, column=0, padx=0, pady=(0, 0))
areeb_label = tk.CTkLabel(sidebar_frame, text="Areeb Kazmi")
areeb_label.grid(row=3, column=0, padx=0, pady=(0, 0))

appearance_mode_label = tk.CTkLabel(sidebar_frame, text="Appearance Mode:", anchor="w")
appearance_mode_label.grid(row=5, column=0, padx=20, pady=(10, 0))
appearance_mode_optionemenu = tk.CTkOptionMenu(sidebar_frame, values=["Light", "Dark", "System"])
appearance_mode_optionemenu.grid(row=6, column=0, padx=20, pady=(10, 10))
scaling_label = tk.CTkLabel(sidebar_frame, text="UI Scaling:", anchor="w")
scaling_label.grid(row=7, column=0, padx=20, pady=(10, 0))
scaling_optionemenu = tk.CTkOptionMenu(sidebar_frame, values=["80%", "90%", "100%", "110%", "120%"])
scaling_optionemenu.grid(row=8, column=0, padx=20, pady=(10, 20))

# Create and place the first button
button1 = tk.CTkButton(root, text="Max Reported Cases by Area", command=show_max_reported_case_by_area, width=200)
button1.place(x=250, y=350, anchor="nw")

# Create and place the second button
button2 = tk.CTkButton(root, text="Central Crime Hotspots", command=central_hotspots_of_crimes, width=200)
button2.place(x=500, y=350, anchor="nw")

# Create and place the third button
button3 = tk.CTkButton(root, text="Crime Characteristic Clusters", command=crime_clusers, width=200)
button3.place(x=750, y=350, anchor="nw")

# Create and place the fourth button
button4 = tk.CTkButton(root, text="Community Detection", command=community_detection, width=200)
button4.place(x=250, y=400, anchor="nw")

# Create and place the fifth button
button5 = tk.CTkButton(root, text="Top 10 Crime Incidences", command=top_ten_crimes, width=200)
button5.place(x=500, y=400, anchor="nw")

# Create and place the sixth button
button6 = tk.CTkButton(root, text="Most Affected Age Group", command=age_most_affected, width=200)
button6.place(x=750, y=400, anchor="nw")

# Create and place the seventh button
button7 = tk.CTkButton(root, text="Most Affected Gender", command=genders_most_affected, width=200)
button7.place(x=250, y=450, anchor="nw")

# Create and place the eighth button
button8 = tk.CTkButton(root, text="Link Prediction", command=link_prediction, width=200)
button8.place(x=500, y=450, anchor="nw")

# Create and place the ninth button
button9 = tk.CTkButton(root, text="Weapon Frequency by Victim Descent", command=Weapon_freq_victm, width=200)
button9.place(x=750, y=450, anchor="nw")

# create textbox
textbox = tk.CTkTextbox(root, width=800, height=250)
textbox.place(x=250, y=10, anchor="nw")


# set default values
appearance_mode_optionemenu.set("Dark")
scaling_optionemenu.set("100%")
textbox.insert("0.0","")


def sidebar_button_event(action):
    print(f"{action} button clicked")


root.mainloop()