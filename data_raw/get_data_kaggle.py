import kagglehub
import os
import shutil
from pathlib import Path

def download_kaggle_data():
    """
    Download dados do dataset Brazilian E-commerce do Kaggle
    e salva na pasta data_raw/csv
    """
    
    # Cria a pasta csv se não existir
    csv_folder = Path("dbt_olist/seeds")
    csv_folder.mkdir(parents=True, exist_ok=True)
    
    print("Baixando dados do Kaggle...")
    
    # Download do dataset
    path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")
    
    print(f"Dataset baixado em: {path}")
    
    # Lista todos os arquivos baixados
    downloaded_files = list(Path(path).glob("*"))
    
    print(f"Arquivos encontrados: {len(downloaded_files)}")
    
    # Move os arquivos para a pasta csv
    for file_path in downloaded_files:
        if file_path.is_file():
            destination = csv_folder / file_path.name
            shutil.copy2(file_path, destination)
            print(f"Arquivo copiado: {file_path.name}")
    
    print(f"\nTodos os arquivos foram salvos em: {csv_folder.absolute()}")

if __name__ == "__main__":
    download_kaggle_data()
