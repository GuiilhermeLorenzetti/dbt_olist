from datetime import datetime, timedelta
import os
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping

default_args = {
    "owner": "airflow",
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

# The path to the dbt project mounted in the container
DBT_PROJECT_PATH = "/opt/airflow/dbt"

# The connection to the database, using environment variables
# We use the ProfileMapping to map Airflow connection or Env vars to dbt profile
profile_config = ProfileConfig(
    profile_name="dbt_olist",
    target_name="dev",
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="airflow_db", # We can use a connection ID or just pass env vars directly if mapped correctly
        # Actually, since we have env vars in the environment matching what dbt expects,
        # we might just want to let dbt find profiles.yml or configure it here.
        # But profiles.yml is INSIDE the project.
        # Cosmos default behavior with profiles_yml_filepath might be easier if we already have it.
        profile_args={
            "host": os.getenv("HOST_DBT_OLIST", "postgres"),
            "port": int(os.getenv("PORT_DBT_OLIST", "5432")),
            "user": os.getenv("USER_DBT_OLIST", "postgres"),
            "password": os.getenv("PASSWORD_DBT_OLIST", "password"),
            "dbname": os.getenv("DBNAME_DBT_OLIST", "dbt_olist"),
            "schema": "dbt_olist_dev",
        },
    ),
)
# WAIT: If profiles.yml exists in the project, we can just point to it!
# However, profiles.yml uses jinja env_var(). Cosmos handles this if we just point to the project 
# and ensure env vars are set in the Airflow environment (which we did).

# So simpler config:
simple_profile_config = ProfileConfig(
    profile_name="dbt_olist",
    target_name="dev",
    # If we don't provide a mapping, Cosmos looks for profiles.yml in the project
    # But we need to make sure it finds it.
    profiles_yml_filepath=f"{DBT_PROJECT_PATH}/profiles.yml",
)

dbt_olist_dag = DbtDag(
    project_config=ProjectConfig(
        dbt_project_path=DBT_PROJECT_PATH,
    ),
    profile_config=simple_profile_config,
    execution_config=ExecutionConfig(
        dbt_executable_path=f"{os.environ.get('AIRFLOW_HOME')}/.local/bin/dbt", # dbt is installed in user local
    ),
    # normal dag parameters
    schedule_interval="@daily",
    start_date=datetime(2025, 1, 1),
    catchup=False,
    dag_id="dbt_olist_cosmos_dag",
    default_args=default_args,
    max_active_tasks=1, # just because is a free tier database
)
