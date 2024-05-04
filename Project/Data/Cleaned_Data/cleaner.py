import pandas as pd

def assign_location_ids(input_file_path, output_file_path):
    """
    Assign a unique location ID to each unique combination of latitude (LAT) and longitude (LON).
    
    Parameters:
    - input_file_path (str): The path to the input CSV file.
    - output_file_path (str): The path to the output CSV file where the modified DataFrame will be saved.
    """
    # Read the input CSV file into a DataFrame
    df = pd.read_csv(input_file_path)
    
    # Group the data by LAT and LON, and assign a unique Location_id to each group
    df['Location_id'] = df.groupby(['LAT', 'LON']).ngroup() + 1
    
    # Save the modified DataFrame with the Location_id column to a new CSV file
    df.to_csv(output_file_path, index=False)

# Usage example
input_file_path = r'D:\Habib University\6th Semester Spring 2024\(CS) Graph Data Science\Project\Datasets\Cleaned_Crime_Data\Crime_Data_from_2020_to_Present.csv'
output_file_path = r'D:\Habib University\6th Semester Spring 2024\(CS) Graph Data Science\Project\Datasets\Cleaned_Crime_Data\Crime_Data_from_2020_to_Present.csv'

# Call the function to assign location IDs and save the result
assign_location_ids(input_file_path, output_file_path)
