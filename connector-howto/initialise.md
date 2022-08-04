# COVID Policy Modelling Model Connector Template

In this how-to you will build a model connector for the COVID-UI system, using a model of your choice.
After completion of the how-to, you should be able to add your specific model connector to a deployment of COVID-UI.

## Contents

* TOC
{:toc}

## Assumptions

The main body of these instructions assume the following:

* The *connector* will be developed in a separate source repository to the model.
* The *connector* will be hosted on GitHub, and use GitHub Actions and GitHub Packages Container Registry
* The *connector* will be developed publicly.
* The *connector* will use the common input and output schema shared with other models.

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
## Next steps

Follow the [steps for building your connector](build.md).
