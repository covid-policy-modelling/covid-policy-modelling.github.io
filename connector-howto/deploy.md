# COVID Policy Modelling Model Connector How-To: Deploying your connector

In this section, you will complete deployment of your connector.
After completion, your connector will be deployed to a COVID-UI, making it available for policy makers and others to run simulations using it.

## Contents

* TOC
{:toc}

## Assumptions

The main body of these instructions assume the following:

* The *connector* will be deployed to the public covid-policy-modelling COVID-UI environment.
* The *connector* will be hosted on GitHub, and use GitHub Actions and GitHub Packages Container Registry
* The *connector* will be developed publicly.
* Either:
  * The *connector* will use the common input and output schema shared with other models.
  * The *connector* will use a different shared schema

The instructions also contain additional notes to support any of the following:

* The *connector* will use a custom schema
* The *connector* will be developed privately.

## Deploying your connector

1. If your connector uses a common schema, refer to the [notes below](#the-connector-will-use-a-custom-schema).

1. Create a [fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) of the [web-ui](https://github.com/covid-policy-modelling/web-ui/) repository (if you have not already done so).

1. Clone your forked repository to your machine (again, if you have not already done so).

1. In your local repository, edit the file **models.yml**.
   Copy the contents of your connector's **meta.yml**, appending them to the end of the file.

1. Edit the file **.override-staging/models.yml**.
   Add lines specifying the latest version of your connector, e.g.

   ```yaml
   <MODEL>:
     imageURL: ghcr.io/<OWNER>/<MODEL>-connector/<MODEL>-connector:<VERSION>
   ```

1. Run the script `script/generate-docs`.

1. Run `git diff`, and you should expect to see changes to **public/openapi.json** to reflect your new model.

1. Run `git commit` and `git push` to push your changes back to your GitHub repository.

1. Create a [pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork) against the [web-ui](https://github.com/covid-policy-modelling/web-ui/) repository with your changes.

1. Maintainers of the web-ui repository should respond your PR, and may request further information or changes.

## Next steps

Once the PR has been accepted, maintainers of the public covid-policy-modelling COVID-UI environment can deploy an updated version of the web-ui in order to make your connector available to users.

## Additional steps for alternative approaches

### The connector will use a custom schema

Before raising your PR, you must first publish your schema by submitting a PR with your changes to the [schemas repository](https://github.com/covid-policy-modelling/schemas).
After that has been completed, you can then prepare your web-ui changes.
In addition to the changes listed above, you will also need to:

  * Install the latest version of the **@covid-policy-modelling/api** package in **package.json**.
  * Add references to your schema in **lib/models.ts**.
  * Add references to your schema in **script/generate-docs**.
