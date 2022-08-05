# COVID Policy Modelling Model Connector How-To: Publishing your connector

In this section, you will build and publish your connector.
After completion, your connector will be available for others to use.

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

The instructions also contain additional notes to support any of the following:

* The *connector* will be developed privately.

## Conventions

{% include conventions.md %}

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

1. Click on "Packages" then select the package for your connector.
   Select "Package settings", then under "Danger Zone", select "Change visibility", and set the visibility to "Public".
   Enter the repository name to confirm.
   * If your connector will be developed privately, refer to the [notes below](#the-connector-will-be-developed-privately).

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

## Next steps

Follow the [steps for deploying your connector](deploy.md).

## Additional steps for alternative approaches

### The connector will be developed privately

*Do not* carry out the step to make your package public.
Instead you must give read access to the `@covid-policy-modelling-bot` user, either directly or by giving it read access to the repository and selecting to inherit those permissions in the package.
When later accessing your package, you may first be required to log in to the GitHub Packages Container Registry using `docker login ghcr.io`.

