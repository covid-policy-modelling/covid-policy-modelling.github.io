# COVID Policy Modelling Model Connector Template

In this how-to you will build a model connector for the COVID-UI system, using a model of your choice.
After completion of the how-to, you should be able to add your specific model connector to a deployment of COVID-UI.

## Contents

* TOC
{:toc}

## Assumptions

The main body of these instructions assume the following:

* The *connector* will be deployed to the public covid-policy-modelling COVID-UI environment.
* The *connector* will be hosted on GitHub, and use GitHub Actions and GitHub Packages Container Registry
* The *connector* will be developed publicly.

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
