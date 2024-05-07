from neo4j import GraphDatabase

uri = "bolt://localhost:7687"  # Change this to your database's URI
username = "Final Project DBMS 30k"  # Change this to your database's username
password = "poledbms"  # Change this to your database's password

driver = GraphDatabase.driver(uri, auth=(username, password))

def run_query(query):
    with driver.session() as session:
        result = session.run(query)
        return [record for record in result]

query = "MATCH (n:Crime) RETURN n"
data = run_query(query)

