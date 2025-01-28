import json
from transformers import BertConfig

def json_to_bert_config(file_path):
    """
    Reads a JSON file from the given file path, converts the values to Python-readable formats,
    and creates a BertConfig object with the attributes matching the JSON keys.
    """
    # Read the JSON file
    with open(file_path, 'r') as f:
        python_data = json.load(f)  # This will automatically handle `true`, `false`, `null` to Python values

    # Create a BertConfig object with the parameters in the python_data dictionary
    config = BertConfig(**python_data)

    return config
