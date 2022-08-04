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
* The *connector* will be deployed to the public covid-policy-modelling COVID-UI environment.
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

## Creating your repository

1. In your browser, visit [model-connector-template repository](https://github.com/covid-policy-modelling/model-connector-template).

1. Click on "Use this template".

1. Fill out the repository details:
    * For "Owner", select an appropriate organisation, or your username.
    * For "Repository name", we recommend "&lt;MODEL&gt;-connector"
    * Select "Public".

1. Click on "Create repository from template".

1. In your terminal, clone your repository with the following command:

   ```bash
   $ git clone https://github.com/<USERNAME>/<MODEL>-connector.git
   ```

1. You will be prompted for a password, which is the [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) created as part of setting up your GitHub account.
   Enter it now.

1. Change directory into your repository:

   ```bash
   $ cd <MODEL>-connector
   ```

1. Obtain a copy of the latest version of the input and output JSON schemas:

   ```bash
   $ curl https://raw.githubusercontent.com/covid-policy-modelling/schemas/main/schema/input-common.json -o input-schema.json
   $ curl https://raw.githubusercontent.com/covid-policy-modelling/schemas/main/schema/output-common.json -o output-schema.json
   ```

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

## Publishing your connector

1. Push your code:

   ```bash
   $ git push
   ```

1. In your browser, go to the URL: https://github.com/&lt;OWNER&gt;/&lt;MODEL&gt;/connector.
   You should see your latest code listed.

1. Click the "Actions" tab.
   Listed on the page, you should see a line for your latest commit, next to either a yellow circle, a green circle with a tick or a red circle with a cross.

   * If the circle is yellow, your connector is being built, and you should wait until it changes to red or green, which should take a minute or two.
   * If the circle is red, something has went wrong. Click on your commit, then "publish", and you should be shown an error. Try to figure out what has went wrong, fix the code, then commit and push again.
   * If the circle is green, your connector has been built successfully.

1. Click the "Code" tab.
   Under the "Packages" heading, you should now see your connector listed as "&lt;MODEL&gt;-connector/&lt;MODEL&gt;-connector".

1. Click on "Packages" then select the package for your connector. Under "Danger Zone", select "Change visibility", and set the visibility to "Public". Enter the repository name to confirm.

1. Test you can access your package now.

   ```bash
   $ docker pull ghcr.io/<OWNER>/<MODEL>-connector/<MODEL>-connector
   ...
   Using default tag: latest
   latest: Pulling from <OWNER/<MODEL>-connector/<MODEL>-connector
   ...
   Status: Downloaded newer image for ghcr.io/<OWNER>/<MODEL>-connector/<MODEL>-connector:latest
   ghcr.io/<USERNAME>/<MODEL>-connector/<MODEL>-connector:latest
   ```

1. Choose an appropriate version number (e.g. v0.0.1), tag your model connector and push the tag.

   ```bash
   $ git tag v<VERSION>
   $ git push --tags
   ```

1. Return to the "Actions" tab, and you should see a line for your tag. Wait again for it to be built successfully.

1. Test you can access the tagged version of your package.

   ```bash
   $ docker pull ghcr.io/<OWNER>/<MODEL>-connector/<MODEL>-connector:<VERSION>
   ...
   ```

## Documenting your connector

1. Edit `meta.yml` to describe what your model/connector supports.
   This records the metadata used in integration with the `web-ui`.

1. Edit `README.md` to describe your connector for yourself and other developers.

1. Commit and push the changes.

## Deploying your connector

1. Raise a PR against the [web-ui](https://github.com/covid-policy-modelling/web-ui/) repository, copying the content of your `meta.yml` into the `models.yml` file.
   You can do this by [forking the repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo) and creating a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork) from your fork.
   Alternatively, you can do this in browser by:

   1. Open [models.yml](https://github.com/covid-policy-modelling/web-ui/blob/main/models.yml).
   1. Click "Fork this project and edit the file" (marked with a pencil icon).
   1. Append your changes to the end of the file
   1. Under "Propose changes", add a meaningful commit message.
   1. Select "Propose changes".

1. Maintainers of the web-ui repository should respond your PR, and may request further information or changes.
   Once the PR has been accepted, maintainers of the public covid-policy-modelling COVID-UI environment can deploy an updated version of the web-ui in order to make your connector available to users.
