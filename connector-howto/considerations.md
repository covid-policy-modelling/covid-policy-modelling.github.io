# COVID Policy Modelling Model Connector How-To: Initial considerations

When building a connector for a specific model, there are a number of considerations which will influence how the connector is created.
In this section, you should consider these specific questions, which address the most common considerations.
After completion, you should be confident in knowing which other documentation to follow.

## Content

* TOC
{:toc}

### How can the model be executed?

Models can be executed in a variety of ways, and some of these are simpler to integrate with a connector than others.
If you have influence over the development of the model itself, you may be in a position to change how it is used in order to simplify the connector.
If you are developing a connector for somebody else's model however, you may be unable to do so, and will have to adapt the connector accordingly.

#### As an interactive script or application

COVID-UI is not suitable for deploying interactive applications, or for workflows that require human intervention, e.g. models that can be run only in `Rstudio`.
You must ensure that any model can be run through one or more command-line instructions (e.g. `Rscript`) that do not expect a user to provide information interactively.

#### As a non-interactive script or application

This is straight-forward, and places few restrictions on building a connector.
In particular, the connector can be written in almost any language, and can use whatever is common in that language for calling external applications, e.g. `subprocess` in Python, `child_process` in Node.js etc.

#### As a library

This is also straight-forward, and if the connector is written in the same language as the model then this is usually the simplest approach.
It is still possible to write the connector in a different language, making use of bindings (e.g. using [ctypes](https://docs.python.org/3/library/ctypes.html?highlight=ctypes#module-ctypes) or [CFFI](https://cffi.readthedocs.io/en/latest/goals.html) in Python), but this is more complex.

### Where will the connector be developed?

Under most circumstances, the best approach is to develop the connector in a standalone repository.
This allows changes to be made to the connector with minimal impact on the development of the model itself.
This is the approach supported by the use of the [model-connector-template](https://github.com/covid-policy-modelling/model-connector-template).

For small teams who wish to minimise the number of repositories they use, it is possible to combine the connector code with the model itself.
This can simplify initial development, but is only appropriate under specific circumstances.
This can be achieved by copying the relevant files from [model-connector-template](https://github.com/covid-policy-modelling/model-connector-template).

### Where can the model be installed from?

As with execution, there are a number of ways to install a model.
If you have influence over the development of the model itself, you may be in a position to change how it is used in order to simplify the connector.
If you are developing a connector for somebody else's model however, you may be unable to do so, and will have to adapt the connector accordingly.

The recommended approaches are to install the model either from a public package repository (e.g. PyPI or CRAN), or through the use of an existing Docker container, if these are available.
If neither of these are possible, it is also possible to install the model from an external location such as a GitHub release or SourceForge, or from a Git repository.

### Where will the connector be deployed?

For your connector to be useful, it needs to be deployed as part of at least one COVID-UI environment.
This could be the (semi-)public environment managed by the maintainers of the [covid-policy-modelling organisation](https://github.com/covid-policy-modelling), or it could be another private environment, run by your organisation or another.
If you intend to use an environment not managed by your own organisation, make sure to communicate with them before beginning any development work - they will be best-placed to advise you whether your model is suitable for their environment.

### What language will the connector be written in?

Connectors can in theory be written in any language.
The principal requirements are that the language can parse and output JSON, and execute the model.

We also recommend that you avoid languages with licensing requirements, e.g. MATLAB or Mathematica, as this complicates the deployment.
If you do want to use such a language, please communicate with the maintainers of the relevant COVID-UI environment to discuss how this can be managed.

If your model is only available as a library, it's recommended to write the connector in the same language.
Otherwise, you can pick the language you are most comfortable with.
Existing connectors and documentation most commonly use Python or Node.js, but connectors have also been written in R, Julia and Mathematica.

### Where will the connector development be hosted?

Development of a connector requires three separate services: source code repository hosting, continuous integration, and container image hosting.
The recommended service for all three is GitHub (respectively GitHub Repositories, GitHub Actions, and GitHub Packages Container Registry).

You can use an alternative service to replace any of these, but there is no further documentation on doing so.
The GitHub Actions workflows included in the [model-connector-template](https://github.com/covid-policy-modelling/model-connector-template) can act as a guide for the necessary steps.

If using an alternative container registry, you should communicate this with the maintainers of the relevant COVID-UI environment, as it may require some minor changes to the relevant control-plane for authentication.

### Will the connector be public or private?

Under most circumstances, the recommended approach is to develop the connector in a public repository.
This is always appropriate if the model source code itself is public, or if the model source code is private but the compiled application is available publicly.
Connector code is usually simple, and there is unlikely to be any benefit to keeping it private.

If the connector code is required to be private (e.g. because the compiled application is not available publicly), this can be achieved by supplying appropriate credentials for the container registry hosting your connector to the maintainers of the relevant COVID-UI environment.
As before, you should communicate with them sooner rather than later.
Additionally, the use of GitHub Actions and GitHub Packages may incur a cost for private repositories.

### What schemas will the connector support?

COVID-UI supports multiple schemas, each of which define the input and output that connectors are expected to support.

#### Common

The primary pair of schemas are the [CommonModelInput](https://github.com/covid-policy-modelling/schemas/blob/main/schema/input-common.json) and [CommonModelOutput](https://github.com/covid-policy-modelling/schemas/blob/main/schema/output-common.json) schemas.
Supporting this schema gives full integration with the user interface of COVID-UI, allowing policy makers to compare different simulations on the same set of input.

Note that in the public COVID-UI environment, connectors are required to *accept* any input of the given schema, but do not necessarily need to *act* on each of the different values.
For example, a connector that uses the value of the `reductionPopulationContact` parameter but ignores the `socialDistancing` parameter is fine.
Similarly, all the documented metrics must be included in the output, but can be set to `0` if the connector does not calculate them.
Other environments may have different expectations.

#### Custom

Because these schemas are complex, and may not map to every model, an alternative approach is to define a specific pair of schemas for your model.
Such connectors cannot be used with COVID-UI web interface at present, but do still allow for simulations to be scheduled through the API.
This requires some [initial work](https://github.com/covid-policy-modelling/schemas/#adding--documenting-schemas) to define the schemas.
The maintainers of the relevant COVID-UI environment may have requirements or restrictions on which schemas they require you to support.
Again, please communicate with them before beginning any development work.

#### Shared

A less-common approach would be to support an existing pair of schemas other than the `CommonModelInput` and `CommonModelOutput`.
The steps for this are mostly similar to using the `CommonModelInput` and `CommonModelOutput`.

#### Multiple

Normally, each connector supports exactly one input schema and one output schema.
If there is a use case for a connector that supports more than one, this could be achieved by alterations to the metadata which define which connectors are deployed.
Please communicate this with the maintainers of the relevant COVID-UI environment for more advice.

### Will you validate the input and output?

While your connector *should* always received data that is valid according to your input schema, we strongly recommend that you always validate the input yourself as the first step of your connector.
This makes debugging any unexpected issues much easier, and is also very helpful when initially developing or updating the connector.
For similar reasons, we also recommend you validate any output before returning it.

JSON Schema validators are available for many languages, and the JSON Schema team maintain a [non-exhaustive list of validators](https://json-schema.org/implementations.html#validators).
You may wish to consider using a different language if a validator is not available for your chosen language.

### What data is needed for the model, and how will it be obtained?

Most models require both code and data, and the line between what is and isn't part of the 'model' can sometimes be blurred.
There are a number of ways data can be obtained in a connector, and this has important implications for the reliability and reproducibility of simulations.
The public COVID-UI environment is primarily intended as a demonstrator, and does not place any restrictions on how data is obtained or used.
Other environments may have different expectations.

#### Supplied in input

When using the `CommonModelInput`, some summary data about total case and death data in the region is supplied, which can be used by the model.
If you have a use case which would benefit from receiving daily case and death data as part of the input, please discuss that with the maintainers of the [covid-policy-modelling organisation](https://github.com/covid-policy-modelling).
It is unlikely that any other data could be handled in this way however.

If you are supporting a different schema, specific to your model, you may choose to define it so that all required data is included as part of the input.
Depending on the amount of data, this may be complicated for users of the connector to manage however.

#### Downloaded at runtime

You may choose to download any required data at runtime from a relevant data source, e.g. data.gov.uk.
This has the advantage that the latest data is always used for any simulation.
However, it does has implications on reliability, as simulations will fail if the external data source is unavailable.
Additionally, it means that simulations are never strictly reproducible.

#### Included in container

You may choose to include any required data in the container.
This could be by downloading it at build-time, or for very small datasets it might be appropriate to include them in the source code repository.
This is also the approach that needs to be taken where data is contained within the target model.

This approach is always reliable and reproducible.
However, it means that the connector must be updated and re-deployed frequently whenever new data is available, which can be time-consuming.

#### Stored externally

A potential half-way approach is to host any required data in an external location, e.g. a database or Git repository.
This can improve (although not completely remove) the reliability issues associated with runtime downloading, particularly if there are many different original data sources.
It also means the connector does not have to updated or redeployed when new data is available.
Where many models may share the same data source, it can also reduce the overheads by avoiding repeated downloads of identical data.
It does however require additional effort to develop and maintain a system for populating and refreshing the external data source.

## Next steps

Follow the [main build steps](initialise.md).
These are appropriate if:

* The *model* is available as a library
* The *model* is installed from a public package repository e.g. PyPI, or CRAN.
* The *connector* will be developed in a separate source repository to the model.
* The *connector* will be deployed to the public covid-policy-modelling COVID-UI environment.
* The *connector* will be developed in the same language as the model.
* The *connector* will be hosted on GitHub, and use GitHub Actions and GitHub Packages Container Registry
* The *connector* will be developed publicly.
* The *connector* will use the common input and output schema shared with other models.
* The *connector* will validate all input and output.
* The *connector* does not require any additional data other than that supplied with the model or provided as input.

In addition, they contain pointers for how to address the following situations:

* The *model* is available as a non-interactive script or application
* The *model* can be installed as a container
* The *model* can be installed from an external location
* The *model* can be installed from a source repository
* The *connector* will be developed privately.
* The *connector* will use a custom schema
* The *connector* will use a different shared schema

## Other configurations

The following configurations are currently unsupported - they are possible to do but we have not documented them.
You may still be able to achieve them by amending the [main build instructions](initialise.md).
We have listed what sections of the instructions are likely to require alterations:

* How to deploy to a different environment (Deploying your connector)
* How to store data in the container (Creating a connector)
* How to access data at runtime (Creating a connector)
* How to access external data (Creating a connector)
* How to develop in the same repository (Creating a repository, Creating a connector, Publishing your connector)
* How to use a different host (Creating a repository, Publishing your connector, Deploying your connector)
* How to develop without validation (Creating a connector)
