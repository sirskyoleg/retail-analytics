# src/genie/deploy_genie_space.py
# Python script для створення/оновлення Genie Space через API

import os
import yaml
from databricks.sdk import WorkspaceClient
from databricks.sdk.service import catalog

def load_config(config_path="config.yaml"):
    """Load Genie Space configuration from YAML"""
    with open(config_path, 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)

def deploy_genie_space(env="dev"):
    """
    Deploy or update Genie Space
    
    Args:
        env: Environment (dev/prod)
    """
    # Initialize Databricks client
    w = WorkspaceClient()
    
    # Load configuration
    config = load_config()
    space_config = config['genie_space']
    
    # Adjust catalog name based on environment
    catalog_name = f"retail_ai3_{env}" if env == "dev" else "retail_ai3"
    
    # Update table identifiers with correct catalog
    tables = [
        f"{catalog_name}.gold.{table}" 
        for table in space_config['tables']
    ]
    
    print(f"Deploying Genie Space to {env} environment...")
    print(f"Catalog: {catalog_name}")
    print(f"Tables: {tables}")
    
    try:
        # Check if space already exists
        space_name = space_config['name']
        existing_spaces = list(w.genie.spaces.list())
        existing_space = None
        
        for space in existing_spaces:
            if space.name == space_name:
                existing_space = space
                break
        
        if existing_space:
            print(f"Updating existing Genie Space: {existing_space.id}")
            # Update space configuration
            w.genie.spaces.update(
                space_id=existing_space.id,
                name=space_name,
                description=space_config['description'],
                table_identifiers=tables
            )
            space_id = existing_space.id
        else:
            print("Creating new Genie Space...")
            # Create new space
            response = w.genie.spaces.create(
                name=space_name,
                description=space_config['description'],
                table_identifiers=tables
            )
            space_id = response.space_id
        
        # Add starter questions
        print("Adding starter questions...")
        for question in space_config['starter_questions']:
            w.genie.spaces.add_starter_question(
                space_id=space_id,
                question=question
            )
        
        # Add benchmark questions
        print("Adding benchmark questions...")
        for benchmark in space_config['benchmarks']:
            w.genie.spaces.add_benchmark(
                space_id=space_id,
                question=benchmark['question'],
                expected_sql=benchmark['sql']
            )
        
        print(f"✅ Genie Space deployed successfully!")
        print(f"Space ID: {space_id}")
        print(f"URL: {w.config.host}/genie/rooms/{space_id}")
        
    except Exception as e:
        print(f"❌ Error deploying Genie Space: {e}")
        raise

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='Deploy Genie Space')
    parser.add_argument('--env', choices=['dev', 'prod'], default='dev',
                       help='Environment to deploy to')
    
    args = parser.parse_args()
    deploy_genie_space(args.env)