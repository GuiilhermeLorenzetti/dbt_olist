import kagglehub
import os
import shutil
from pathlib import Path

def download_kaggle_data():
    """
    Download Brazilian E-commerce dataset from Kaggle
    and save to data_raw/csv folder
    """
    
    # Create csv folder if it doesn't exist
    csv_folder = Path("dbt_olist/seeds")
    csv_folder.mkdir(parents=True, exist_ok=True)
    
    print("Downloading data from Kaggle...")
    
    # Dataset download
    path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")
    
    print(f"Dataset downloaded at: {path}")
    
    # List all downloaded files
    downloaded_files = list(Path(path).glob("*"))
    
    print(f"Files found: {len(downloaded_files)}")
    
    # Move files to csv folder
    for file_path in downloaded_files:
        if file_path.is_file():
            destination = csv_folder / file_path.name
            shutil.copy2(file_path, destination)
            print(f"File copied: {file_path.name}")
    
    print(f"\nAll files were saved in: {csv_folder.absolute()}")

if __name__ == "__main__":
    download_kaggle_data()
