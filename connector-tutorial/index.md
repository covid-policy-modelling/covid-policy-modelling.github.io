# COVID Policy Modelling Model Connector Tutorial

In this tutorial you will build a model connector for the COVID-UI system, using an SIR model developed in Python.
After completion of the tutorial, you should be comfortable with the general concepts of the COVID-UI system, and able to follow additional documentation on how to add your specific model (which may be in any language, not just Python) to COVID-UI.

## Contents

* TOC
{:toc}

## Prerequisites

For this tutorial you will need to have the following tooling installed in your system:

* Docker, through either:
  * [Docker Desktop](https://www.docker.com/products/docker-desktop) or
  * (Available separately on Linux only) [Docker Engine](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/engine/install/)
* Git
* Terminal (on Windows, Git Bash will be installed as part of the official Git for Windows client)
* curl (on Windows, this will be available in Git Bash)
* Text editor

In addition, you will need a [GitHub account](https://github.com/signup).

## Assumptions

The tutorial assumes a basic knowledge of using Docker and Docker Compose.
If you are not comfortable with those topics, we recommend the [Docker Getting Started documentation](https://docs.docker.com/get-started/), although it does cover a number of aspects that are not relevant to this tutorial or to writing connectors.
In particular, parts 4 (Share the application), 5 (Persist the DB), 7 (Multi-container apps) and 9 (Image-building best practices) are not needed to understand this tutorial.

This tutorial also assumes a basic knowledge of using Git and GitHub.
If you are not comfortable with those topics, we recommend the [GitHub Get Started documentation](https://docs.github.com/en/get-started).
Again, this covers a large number of more advanced aspects than are necessary for the tutorial.
The main sections that are necessary to follow this tutorial are:

* [Getting started](https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account)
* [Creating a PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
* [Set up Git](https://docs.github.com/en/get-started/quickstart/set-up-git)
* [Create a repository from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)
* [About remote repositories](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories)
* [Pushing commits to a remote repository](https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository)

## Conventions

{% include conventions.md %}

## Steps

### Creating your repository

1. In your browser, visit the [model-connector-template repository](https://github.com/covid-policy-modelling/model-connector-template).

1. Click on "Use this template".

1. Fill out the repository details:
    * For "Owner", check that your username is selected.
    * For "Repository name", enter "tutorial-model-connector".
    * Select "Private".

1. Click on "Create repository from template".

1. In your terminal, clone your repository with the following command:

   ```bash
   $ git clone https://github.com/<USERNAME>/tutorial-model-connector.git
   ```

1. You will be prompted for a password, which is the [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) created as part of setting up your GitHub account.
   Enter it now.

1. Change directory into your repository:

   ```bash
   $ cd tutorial-model-connector
   ```

1. Obtain a copy of the latest version of the input and output JSON schemas:

   ```bash
   $ curl https://raw.githubusercontent.com/covid-policy-modelling/schemas/main/schema/input-minimal.json -o input-schema.json
   $ curl https://raw.githubusercontent.com/covid-policy-modelling/schemas/main/schema/output-minimal.json -o output-schema.json
   ```

1. Obtain a copy of the SIR model and associated requirements:

    ```bash
    $ curl https://covid-policy-modelling.github.io/connector-tutorial/model.py -o model.py
    $ curl https://covid-policy-modelling.github.io/connector-tutorial/requirements.txt -o requirements.txt
    ```

### Creating a Dockerfile

1. The first requirement of a model connector is that it must be a Docker image.
   To build the image, you will need to create a file named **Dockerfile**.
   A sample one is included in the template.
   Using your text editor, edit the file **Dockerfile** to replace the contents with the following:

   ```Dockerfile
   FROM python:3.9.12-slim-buster

   ARG CONNECTOR_VERSION=latest
   ENV CONNECTOR_VERSION=${CONNECTOR_VERSION}

   COPY requirements.txt /app/requirements.txt
   RUN python3 -m pip install -r /app/requirements.txt

   COPY *.json *.py /app/

   CMD ["python3", "/app/connector.py", "/data/input/inputFile.json", "/data/output/data.json", "/app/input-schema.json", "/app/output-schema.json"]
   ```

1. It's not necessary to understand the details of this at the moment, but you should remember that all of the lines in this file apart from the final `CMD` define what happens when the image is *built*, and that the `CMD` line defines what happens when the image is *run*.

1. Build your image now (this might take some time):

   ```bash
   $ docker-compose build run-model
   ...
   Successfully tagged tutorial-model-connector_run-model:latest
   ```

1. Next, test your connector code, which should result in an error:

   ```bash
   $ docker-compose run --rm run-model
   Creating tutorial-model-connector_run-model_run ... done
   python3: can't open file '/app/connector.py': [Errno 2] No such file or directory
   ERROR: 2
   ```

### Creating your connector

1. The previous error comes from trying to run the command specified in the **Dockerfile** with `CMD`, although **connector.py** doesn't exist yet. Create that now:

   ```bash
   $ touch connector.py
   ```

   1. Using your text editor, edit the file **connector.py** to contain the following:

   ```python
   #! /usr/bin/env python3
   import logging
   import os
   import sys

   logging.basicConfig(level=logging.DEBUG)

   model_description = {
       "name": "model-connector-tutorial",
       "modelVersion": os.getenv("CONNECTOR_VERSION"),
       "connectorVersion": os.getenv("CONNECTOR_VERSION"),
   }

   model_input_fn = sys.argv[1]
   model_output_fn = sys.argv[2]
   model_input_schema_fn = sys.argv[3]
   model_output_schema_fn = sys.argv[4]

   logging.info('Starting connector')
   ```

1. Build and run the image again (this time, you shouldn't see an error):

   ```bash
   $ docker-compose build run-model
   Successfully tagged tutorial-model-connector_run-model:latest
   $ docker-compose run --rm run-model
   Creating tutorial-model-connector_run-model_run ... done
   INFO:root:Starting connector
   ```

### Validating the output

1. The connector now runs successfully, but it doesn't produce any output.
   An additional command can be used to check the output, and confirm this:

   ```bash
   $ docker-compose run --rm validate
   Creating tutorial-model-connector_validate_run ... done
   error:  Cannot find data file output/data.json '/data/output/data.json'
   ERROR: 2
   ```

1. Using your text editor, edit the file **connector.py** again to add the following:

   ```python
   #! /usr/bin/env python3
   import logging
   import os
   import sys
   import json

   ...

   logging.info('Starting connector')

   model_output = {
       'outputs': [],
       't': [],
       'u': [],
   }
   model_output['model'] = model_description
   logging.debug(f'Simulation result: {model_output}')

   # Save outputs
   with open(model_output_fn, 'w') as f:
       json.dump(model_output, f, indent='  ')

   logging.info('Simulation successfully completed')
   ```

1. Build, run and validate the model again:

   ```bash
   $ docker-compose build run-model
   Successfully tagged tutorial-model-connector_run-model:latest
   $ docker-compose run --rm run-model
   Creating tutorial-model-connector_run-model_run ... done
   INFO:root:Starting connector
   DEBUG:root:Simulation results: {'outputs': [], 't', 'u': []}
   INFO:root:Simulation successfully completed
   $ docker-compose run --rm validate
   output/data.json invalid
   [ { keyword: 'required',
       dataPath: '',
       schemaPath: '#/required',
       params: { missingProperty: 'metadata' },
       message: 'should have required property \'metadata\'' },
     { keyword: 'type',
       dataPath: '',
       schemaPath: '#/anyOf/1/type',
       params: { type: 'array' },
       message: 'should be array' },
     { keyword: 'anyOf',
       dataPath: '',
       schemaPath: '#/anyOf',
       params: {},
       message: 'should match some schema in anyOf' } ]
   ERROR: 1
   ```

1. This time, the connector produced output, but the output was not valid, and the validator produced an error message.
   You may find the error difficult to understand for now, but there will be more explanation on how to fix it later.
   First though, to make things simpler, you can remove the need to run a separate validation step by adding the validation into the connector itself.
   Using your text editor, edit the file **connector.py** again:

   ```python
   #! /usr/bin/env python3
   import logging
   import os
   import sys
   import json
   import jsonschema

   ...

   logging.debug(f'Simulation result: {model_output}')

   with open(model_output_schema_fn) as f:
       model_output_schema = json.load(f)
       jsonschema.validate(model_output, model_output_schema)

   # Save outputs
   with open(model_output_fn, 'w') as f:
       json.dump(model_output, f, indent='  ')

   logging.info(f'Simulation successfully completed')
   ```

1. Build and run the model again:

   ```bash
   $ docker-compose build run-model
   Successfully tagged tutorial-model-connector_run-model:latest
   $ docker-compose run --rm run-model
   Creating tutorial-model-connector_run-model_run ... done
   INFO:root:Starting connector
   DEBUG:root:Simulation results: {'outputs': [], 't', 'u': []}
   INFO:root:Simulation successfully completed

   Traceback (most recent call last):
     File "/app/connector.py", line 25, in <module>
       jsonschema.validate(model_output, model_output_schema)
     File "/usr/local/lib/python3.9/site-packages/jsonschema/validators.py", line 1059, in validate
       raise error
   jsonschema.exceptions.ValidationError: 'metadata' is a required property

   Failed validating 'required' in schema[0]:
       {'additionalProperties': False,
        'properties': {'metadata': {'$ref': '#/definitions/MinimalModelInput'},
                       'model': {'$ref': '#/definitions/ModelDescription'},
                       'outputs': {'description': 'Optional vector of outputs',
                                   'items': {'type': 'number'},
                                   'type': 'array'},
                       't': {'description': 'Vector of times at which the '
                                            'model is run',
                             'items': {'type': 'number'},
                             'type': 'array'},
                       'u': {'description': 'Matrix of states',
                             'items': {'items': {'type': 'number'},
                                       'type': 'array'},
                             'type': 'array'}},
        'required': ['metadata', 'model', 't', 'u'],
        'title': 'Minimal Model Output',
        'type': 'object'}

   On instance:
       {'outputs': [], 't': [], 'u': []}

   ERROR: 1
   ```

### Reading input data

1. As expected, another error was produced.
   You might notice that the error message is not exactly the same as before.
   That's because the library used inside the connector (**jsonschema**) is not the same as that used by the `docker-compose run validate` command.
   However, they both do the same thing - validate the output of the simulation against the JSON Schema defined in **output-schema.json**.
   The important part of the error is the message: `'metadata' is a required property`.
   This tells us that the output was missing a `metadata` key.

1. You can open the **output-schema.json** file to read the definition of the schema.
   JSON Schema can be difficult to understand however.
   You may find it easier to examine the [generated documentation](https://github.com/covid-policy-modelling/schemas/blob/main/docs/output-minimal.md#minimal-model-output) or the [TypeScript source](https://github.com/covid-policy-modelling/schemas/blob/main/src/output-minimal.ts).

1. To fix the error, you need to add the `metadata` key to the output.
   The `metadata` key needs to contain the input that was used for the simulation, so the input needs to be read in.
   Additionally, it's best to check the input itself is valid, according to the input schema.

   Using your text editor, edit the file **connector.py** again:

   ```python
   #! /usr/bin/env python3
   import logging
   import os
   import sys
   import json
   import jsonschema

   ...

   logging.info('Starting connector')

   # Read input and validate
   with open(model_input_fn) as f:
       model_input = json.load(f)
       logging.debug(f'Simulation input: {model_input}')

   with open(model_input_schema_fn) as f:
       model_input_schema = json.load(f)
       jsonschema.validate(model_input, model_input_schema)
   ...

   model_output['metadata'] = model_input
   model_output['model'] = model_description
   logging.debug(f'Simulation result: {model_output}')

   ...
   ```

1. Build and run the model again:

   ```bash
   $ docker-compose build run-model
   Successfully tagged tutorial-model-connector_run-model:latest
   $ docker-compose run --rm run-model
   Creating tutorial-model-connector_run-model_run ... done
   INFO:root:Starting connector
   DEBUG:root:Simulation input: {'region': 'US', 'subregion': 'US-WY', 'parameters': {'r0': None, 'calibrationDate': '2020-04-18', 'calibrationCaseCount': 1400, 'calibrationDeathCount': 200, 'interventionPeriods': [{'startDate': '2020-03-15', 'reductionPopulationContact': 15, 'socialDistancing': 'moderate'}, {'startDate': '2020-03-21', 'reductionPopulationContact': 65, 'socialDistancing': 'moderate', 'schoolClosure': 'aggressive'}, {'startDate': '2020-03-25', 'reductionPopulationContact': 90, 'socialDistancing': 'aggressive', 'schoolClosure': 'aggressive'}, {'startDate': '2020-05-01', 'reductionPopulationContact': 50, 'socialDistancing': 'moderate', 'schoolClosure': 'mild'}, {'startDate': '2020-06-01', 'reductionPopulationContact': 0}]}}
   Traceback (most recent call last):
     File "/app/connector.py", line 23, in <module>
       jsonschema.validate(model_input, model_input_schema)
     File "/usr/local/lib/python3.9/site-packages/jsonschema/validators.py", line 1059, in validate
       raise error
   jsonschema.exceptions.ValidationError: Additional properties are not allowed ('parameters', 'region', 'subregion' were unexpected)

   ...
   ```

1. This time, you should receive an error because the input is not valid according to **input-schema.json**.
   The test input can be found in **test-job.json**.
   Using your text editor, edit the file **test-job.json** to replace the contents with the following:

   ```json
   {"p": [0.25, 0.25], "u0": [0.99, 0.01, 0.0], "tspan": [0.0, 10000.0]}
   ```

1. Run the model again (note that since you only changed the test data, you don't need to build it again):

   ```bash
   $ docker-compose run --rm run-model
   Creating tutorial-model-connector_run-model_run ... done
   INFO:root:Starting connector
   DEBUG:root:Simulation input: {'p': [0.25, 0.25], 'u0': [0.99, 0.01, 0.0], 'tspan': [0.0, 10000.0]}
   DEBUG:root:Simulation results: {'outputs': [], 't': [], 'u': [], 'metadata': {'p': [0.25, 0.25], 'u0': [0.99, 0.01, 0.0], 'tspan': [0.0, 10000.0]}, 'model': {'name': 'model-connector-tutorial', 'modelVersion': 'latest', 'connectorVersion': 'latest'}}
   INFO:root:Simulation successfully completed
   ```

### Carrying out a simulation

1. You've now successfully created a model connector.
   You might have noticed however that the model didn't actually do any simulation.
   Using your text editor, edit the file **connector.py** to change the following:

   ```python
   #! /usr/bin/env python3
   ...
   import model

   ...

   logging.info('Executing simulation')
   model_output = model.simulate(**model_input)
   model_output['metadata'] = model_input
   model_output['model'] = model_description
   logging.debug(f'Simulation result: {model_output}')

   ...
   ```

1. Build and run the model again:

   ```bash
   $ docker-compose build run-model
   Successfully tagged tutorial-model-connector_run-model:latest
   $ docker-compose run --rm run-model
   Creating tutorial-model-connector_run-model_run ... done
   INFO:root:Starting connector
   DEBUG:root:Simulation input: {'p': [0.25, 0.25], 'u0': [0.99, 0.01, 0.0], 'tspan': [0.0, 10000.0]}
   DEBUG:root:Simulation results: {'t': [0.0, 0.09292317588658758, 1.0221549347524634, 10.314472523411222, 41.80076941422908, 86.17840661151173, 118.7440564498072, 151.3097062881027, 187.35774843504515, 228.4370475700178, 278.5483935588215], 'u': [[0.99, 0.9897700687613326, 0.9874768884813327, 0.9653771612672671, 0.9089609928820541, 0.8759121917292295, 0.8686422606461219, 0.8661474627129668, 0.8652617692832272, 0.8649810345469291, 0.8649045610757414], [0.01, 0.009997650487150558, 0.009971260821892527, 0.009436760454369938, 0.005626842609459851, 0.001643971854307964, 0.0005778676052983578, 0.0001961511215415059, 5.866623832777841e-05, 1.4876265757170764e-05, 2.9294676377868774e-06], [0.0, 0.00023228075151689067, 0.0025518506967746914, 0.02518607827836291, 0.08541216450848596, 0.1224438364164625, 0.13077987174857966, 0.13365638616549158, 0.13467956447844492, 0.1350040891873136, 0.13509250945662063]], 'outputs': [0.13509250945662063, 0.010000000000000002, 0.0], 'metadata': {'p': [0.25, 0.25], 'u0': [0.99, 0.01, 0.0], 'tspan': [0.0, 10000.0]}, 'model': {'name': 'model-connector-tutorial', 'modelVersion': 'latest', 'connectorVersion': 'latest'}}
   INFO:root:Simulation successfully completed
   ```
1. The output is also saved to a file.
   You can view it by running:

   ```bash
   $ cat output/data.json
   ```

### Publishing your connector

1. Review your completed **connector.py** file and ensure it matches the [expected final connector](connector.py).

1. In order to publish your connector, you need to push your code to your remote GitHub repository.
   Note that while we use the term publish, the connector is still private by default and nobody except you will be able to access it.

   ```bash
   $ git add .
   $ git commit -m "Add initial connector"
   $ git push
   ```

1. In your browser, go to the URL: **https://github.com/&lt;USERNAME&gt;/tutorial-model-connector**.
   You should see your latest code listed.

1. Click the "Actions" tab.
   Listed on the page, you should see a line that says "Add initial connector", next to either a yellow circle, a green circle with a tick or a red circle with a cross.

   * If the circle is yellow, your connector is being built, and you should wait until it changes to red or green, which should take a minute or two.
   * If the circle is red, something has went wrong. Click on "Add initial connector", then "publish", and you should be shown an error. Try to figure out what has went wrong, fix the code, then commit and push again.
   * If the circle is green, your connector has been built successfully.

1. Click the "Code" tab.
   Under the "Packages" heading, you should now see your connector listed as "tutorial-model-connector/tutorial-model-connector".

1. Test you can access your package now.
   You may be asked for your GitHub username and password during the first command.

   ```bash
   $ docker login ghcr.io
   ...
   $ docker pull ghcr.io/<USERNAME>/tutorial-model-connector/tutorial-model-connector
   ...
   Using default tag: latest
   latest: Pulling from <USERNAME/tutorial-model-connector/tutorial-model-connector
   ...
   Status: Downloaded newer image for ghcr.io/<USERNAME>/tutorial-model-connector/tutorial-model-connector:latest
   ghcr.io/<USERNAME>/tutorial-model-connector/tutorial-model-connector:latest
   ```

## Next steps

If you are interested in building a model connector for a real model, please see our [how-to documentation](../connector-howto).

## Notes

For reference, the completed files referred to in this tutorial are:

* [connector.py](connector.py)
* [Dockerfile](Dockerfile)
* [model.py](model.py)
* [requirements.txt](requirements.txt)
