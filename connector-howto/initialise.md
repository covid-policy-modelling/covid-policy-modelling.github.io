# COVID Policy Modelling Model Connector How-To: Create repository

In this section, you will create a repository to begin development.
After completion, you should have all the initial files needed to carry on with further steps.

## Contents

* TOC
{:toc}

## Assumptions

The main body of these instructions assume the following:

* The *connector* will be developed in a separate source repository to the model.
* The *connector* will be hosted on GitHub, and use GitHub Actions and GitHub Packages Container Registry
* The *connector* will be developed publicly.
* The *connector* will use the common input and output schema shared with other models.

The instructions also contain additional notes to support any of the following:

* The *connector* will be developed privately.
* The *connector* will use a custom schema
* The *connector* will use a different shared schema

## Conventions

{% include conventions.md %}

## Creating your repository

1. In your browser, visit [model-connector-template repository](https://github.com/covid-policy-modelling/model-connector-template).

1. Click on "Use this template".

1. Fill out the repository details:
   * For "Owner", select an appropriate organisation, or your username.
   * For "Repository name", we recommend "&lt;MODEL&gt;-connector".
   * Select "Public".
   * If your connector will be developed privately, refer to the [notes below](#the-connector-will-be-developed-privately).

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

   * If your connector does not use the common schema, refer to the notes below:
     * [The connector will use a custom schema](#the-connector-will-use-a-custom-schema)
     * [The connector will use a different shared schema](#the-connector-will-use-a-different-shared-schema)

## Next steps

Follow the [steps for building your connector](build.md).

## Additional steps for alternative approaches

### The connector will be developed privately

Select "Private" instead of "Public".
All other settings should remain the same.

### The connector will use a custom schema

You will first need to define and build a schema using the [schema documentation](https://github.com/covid-policy-modelling/schemas/#adding--documenting-schemas).
You can then copy the generated schema files into your connector repository.
We recommend not publishing your schema until you have completed testing your connector.
You will need to publish it however before you connector can be deployed.

### The connector will use a different shared schema

Instead of the common input and output schema, you should download the [appropriate files for your chosen schema](https://github.com/covid-policy-modelling/schemas/tree/main/schema).
