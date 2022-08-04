# COVID Policy Modelling Model Connector Template

In this how-to you will build a model connector for the COVID-UI system, using a model of your choice.
After completion of the how-to, you should be able to add your specific model connector to a deployment of COVID-UI.

## Contents

* TOC
{:toc}

## Assumptions

The main body of these instructions assume the following:

* The *model* is available as a library
* The *model* is installed from a public package repository e.g. PyPI, or CRAN.
* The *connector* will be developed in a separate source repository to the model.
* The *connector* will be developed in the same language as the model.
* The *connector* will be hosted on GitHub, and use GitHub Actions and GitHub Packages Container Registry
* The *connector* will be developed publicly.
* The *connector* will use the common input and output schema shared with other models.
* The *connector* will validate all input and ouput.
* The *connector* does not require any additional data other than that supplied with the model or provided as input.

The instructions also contain links to other documents to support any of the following:

* The *model* is available as a non-interactive script or application
* The *model* can be installed in a container
* The *model* can be installed from an external location
* The *model* can be installed from a source repository

## Conventions

{% include conventions.md %}

## Creating a connector

Develop your connector by editing the `Dockerfile`, connector code and test input, then building, running and validating your connector.
The below process is best followed iteratively, starting with a basic connector with dummy behaviour, and then making alterations, testing and validating throughout.
This process includes only the high-level steps required - further details may be found in the `README.md` file in your connector repository.

1. If your model is not available as a library, follow this process in conjunction with other relevant documentation

   * [Executable](executable.md)
   * [Container](container.md)
   * [Repository](repository.md)
   * [External](external.md)

1. Edit the file `Dockerfile` to install the model, along with your connector code:

   * Set an appropriate base image for your language e.g. [python](https://hub.docker.com/_/python), [r-base](https://hub.docker.com/_/r-base) etc.
     * (Recommended) Pin to a specific version, e.g. `python:3.9` - the level of specificity may vary according to the language's conventions, requirement for reproducibility, frequency of development etc.
   * Install the model code using the usual conventions for your language, e.g. using `pip` for Python (as shown in the [tutorial](../connector-tutorial/Dockerfile))
   * Install a [JSON Schema validator](https://json-schema.org/implementations.html#validators) as well.
   * Add the connector code using [COPY](https://docs.docker.com/engine/reference/builder/#copy).
   * Add the schema files using `COPY` as well
   * Set the `CMD` to run your connector code, passing in as parameters:
     * input location (`/data/input/inputFile.json`)
     * output location (`/data/output/output.json`)
     * input schema location (from your `COPY` command)
     * output schema location (from your `COPY` command)

1. Create your connector code, which needs to:

   * Parse the input JSON file.
   * Validate the input against the schema file.
   * Run a simulation using the model, interpreting the input parameters appropriately as suitable for the model.
     * You must check the `region` and `subregion` parameters, and either produce results pertaining to that subregion or exit with an error if the subregion is not supported.
     * You should support as many of the `inteventionPeriod` parameters as is appropriate for the model, but can ignore any (or all) of them if necessary.
     * For more information on the format of the file, you can refer to an [annotated example](https://github.com/covid-policy-modelling/schemas/blob/main/docs/input-common-annotated.json) or [schema documentation](https://github.com/covid-policy-modelling/schemas/blob/main/docs/input-common.md)
   * Convert the output of the simulation into an object matching the output schema.
     * All `metric` keys are required. For any metrics that the model does not support, you should return an array of appropriate length, consisting of `0` values.
     * For more information on the format of the file, you can refer to [annotated example](https://github.com/covid-policy-modelling/schemas/blob/main/docs/output-common-annotated.json) or [schema documentation](https://github.com/covid-policy-modelling/schemas/blob/main/docs/output-common.md).
   * Validate the output against the schema file.
   * Exit with a zero status if the simulation succeeded, or a non-zero status otherwise.
     * For many languages, this is default behaviour.

1. Edit the test data in `test-job.json`.

1. Build your image (this might take some time on first run, but subsequent runs will usually be quicker):

   ```bash
   $ docker-compose build run-model
   ...
   Successfully tagged <MODEL>-connector_run-model:latest
   ```

1. Test your connector code:

   ```bash
   $ docker-compose run --rm run-model
   Creating <MODEL>-connector_run-model_run ... done
   ...
   ```

1. Validate the output of your connector code:

   ```bash
   $ docker-compose run --rm validate
   Creating <MODEL>-connector_validate_run ... done
   ...
   ```

1. Commit your changes:

   ```bash
   $ git add ...
   $ git commit -m "..."
   ```

## Next steps

Follow the [steps for documenting your connector](document.md).
