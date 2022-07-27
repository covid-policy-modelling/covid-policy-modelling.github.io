#! /usr/bin/env python3
import logging
import sys
import json
import jsonschema
import os
import model

logging.basicConfig(level=logging.DEBUG)

model_input_fn = sys.argv[1]
model_output_fn = sys.argv[2]
model_input_schema_fn = sys.argv[3]
model_output_schema_fn = sys.argv[4]

model_description = {
    "name": "model-connector-tutorial",
    "modelVersion": os.getenv("CONNECTOR_VERSION"),
    "connectorVersion": os.getenv("CONNECTOR_VERSION"),
}

logging.info('Starting connector')

# Read input and validate
with open(model_input_fn) as f:
    model_input = json.load(f)
    logging.debug(f'Simulation input: {model_input}')

with open(model_input_schema_fn) as f:
    model_input_schema = json.load(f)
    jsonschema.validate(model_input, model_input_schema)

model_output = model.simulate(**model_input)
model_output['metadata'] = model_input
model_output['model'] = model_description
logging.debug(f'Simulation results: {model_output}')

with open(model_output_schema_fn) as f:
    model_output_schema = json.load(f)
    jsonschema.validate(model_output, model_output_schema)

# Save outputs
with open(model_output_fn, 'w') as f:
    json.dump(model_output, f, indent='  ')

logging.info('Simulation successfully completed')
