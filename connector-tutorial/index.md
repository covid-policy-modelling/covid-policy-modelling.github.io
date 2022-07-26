# COVID Policy Modelling Model Connector Tutorial

In this tutorial you will build a model connector for the COVID-UI system, using an SIR model developed in Python.
After completion of the tutorial, you should be comfortable with the general concepts of the COVID-UI system, and able to follow additional documentation on how to add your specific model (which may be in any language, not just Python) to COVID-UI.

## Content

* [Prerequisites](#prerequisites)
* [Assumptions](#assumptions)
* [Process](#process)
* [Requirements for Docker images](#requirements-for-docker-images)
* [Input](#input)
* [Output](#output)
* [Updating your model](#updating-your-model)
* [Alternative integrations](#alternative-integrations)
* [Examples](#examples)

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

* https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account
* https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
* https://docs.github.com/en/get-started/quickstart/set-up-git
* https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template
* https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories
* https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository

Throughout this tutorial, there are commands or instructions which require information specific to you, e.g. your GitHub username.
These are written in capital letters and surrounded by angle brackets, e.g. `<USERNAME>`.
Always replace these with the appropriate information (which should be clear from context).
For example, if your GitHub username was `octocat`, then an instruction to enter the command `git clone https://github.com/<USERNAME>/tutorial-model-connector.git` means that you should enter `git clone https://github.com/octocat/tutorial-model-connector.git`.

## Process

1. In your browser, visit [model-connector-template repository](https://github.com/covid-policy-modelling/model-connector-template).

1. Click on "Use this template".

1. For "Owner", check that your username is selected.

1. For "Repository name", enter "tutorial-model-connector".

1. Select "Private".

1. Click on "Create repository from template".

1. In your terminal, clone your repository with the following command:

    ```bash
    git clone https://github.com/<USERNAME>/tutorial-model-connector.git
    ```

1. You will be prompted for a password, which is the [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) created as part of setting up your GitHub account.
   Enter it now.

1. Change directory into your repository:

    ```bash
    cd tutorial-model-connector
    ```

1. Obtain a copy of the latest version of the input and output JSON schemas:

    ```bash
    curl https://raw.githubusercontent.com/covid-policy-modelling/schemas/main/schema/input-minimal.json -o input-schema.json
    curl https://raw.githubusercontent.com/covid-policy-modelling/schemas/main/schema/output-minimal.json -o output-schema.json
    ```

1. Obtain a copy of the SIR model and associated requirements:

    ```bash
    curl https://covid-policy-modelling.github.io/connector-tutorial/model.py -o model.py
    curl https://covid-policy-modelling.github.io/connector-tutorial/requirements.txt -o requirements.txt
    ```

1. Create a file called `connector.py`:

    ```bash
    touch connector.py
    ```

1. Using your text editor, edit the file `connector.py` to contain the following:

    ```python
    #! /usr/bin/env python3
    import logging
    import sys
    import os
    import json
    import jsonschema

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

    # Read schema
    model_input_schema = json.load(open(model_input_schema_fn, 'r'))
    model_output_schema = json.load(open(model_output_schema_fn, 'r'))

    logging.info('Starting connector')

    # Read input and validate
    model_input = json.load(open(model_input_fn, 'r'))
    logging.debug(f'Simulation input: {model_input}')

    jsonschema.validate(model_input, model_input_schema)

    logging.info('Executing simulation')
    model_output = {
        'outputs': [],
        't': [],
        'u': [],
    }
    model_output['metadata'] = model_input
    model_output['model'] = model_description
    logging.debug(f'Simulation result: {model_output}')

    jsonschema.validate(model_output, model_output_schema)

    # Save outputs
    with open(model_output_fn, 'w') as f:
        json.dump(model_output, f, indent='  ')

    logging.info(f'Simulation successfully completed')
    ```

1. Using your text editor, edit the file `Dockerfile` to contain the following:

    ```Dockerfile
    FROM python:3.9.12-slim-buster

    ARG CONNECTOR_VERSION=latest
    ENV CONNECTOR_VERSION=${CONNECTOR_VERSION}

    COPY requirements.txt /app/requirements.txt
    RUN python3 -m pip install -r app/requirements.txt

    COPY . /app

    CMD ["python3", "/app/connector.py", "/data/input/inputFile.json", "/data/output/data.json", "/app/input-schema.json", "/app/output-schema.json"]
    ```

1. Using your text editor, edit the file `test-job.json` to contain the following:

    ```json
    {"p": [0.25, 0.25], "u0": [0.99, 0.01, 0.0], "tspan": [0.0, 10000.0]}
    ```

1. Build your image by running `docker-compose build run-model`.

1. Test your connector code by running `docker-compose run run-model`.

1. The output of your simulation can be found in `output/data.json`. You can view the output with:

    ```bash
    cat output/data.json
    ```

1. Validate the output of your connector by running `docker-compose run --rm validate`.

1. You've now successfully created a model connector.
   You might have noticed however that the model didn't actually do any simulation.
   Using your text editor, edit the file `connector.py` to change the following:

    ```python
    #! /usr/bin/env python3
    ...
    import model

    ...

    logging.info('Executing simulation')
    logging.debug(f'Simulation result: {model_output}')
    logging.info('Executing simulation')
    model_output = model.simulate(**model_input)
    model_output['metadata'] = model_input
    model_output['model'] = model_description
    logging.debug(f'Simulation result: {model_output}')

    ...
    ```

1. Build your image by running `docker-compose build run-model`.

1. Test your connector code by running `docker-compose run run-model`.

1. View the output with:

    ```bash
    cat output/data.json
    ```

1. Validate the output of your connector by running `docker-compose run --rm validate`.

1. Using your text editor, edit the file `test-job.json` to change some of the parameters, e.g.:

    ```json
    {"p": [0.55, 0.15], "u0": [0.98, 0.01, 0.0], "tspan": [0.0, 10000.0]}
    ```

1. Run the model again with `docker-compose run run-model`.

1. View the output with:

    ```bash
    cat output/data.json
    ```

