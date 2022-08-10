# COVID Policy Modelling Model Connector How-To: Documenting your connector

In this section, you will complete the metadata and documentation for your connector.
After completion, you should have the information required to integrate the connector with COVID-UI, and to support future development.

## Contents

* TOC
{:toc}

## Assumptions

The main body of these instructions assume the following:

* The *connector* will use the common input and output schema shared with other models

The instructions also contain additional notes to support any of the following:

* The *connector* will use a custom schema
* The *connector* will use a different shared schema

## Documenting your connector

1. Edit **meta.yml** to describe what your model/connector supports.
   This records the metadata used in integration with the **web-ui**.

   * If your connector does not use the common schema, refer to the notes below:
     * [The connector will use a custom schema](#the-connector-will-use-a-custom-schema)
     * [The connector will use a different shared schema](#the-connector-will-use-a-different-shared-schema)

1. Edit **README.md** to describe your connector for yourself and other developers.

1. Commit and push the changes.

## Next steps

Follow the [steps for publishing your connector](publish.md).

## Additional steps for alternative approaches

### The connector will use a custom schema

In your **meta.yml** you must specify which schema you use, e.g.

```yml
supportedSchemas:
  input: MyModelInput
  output: MyModelOutput
```

You should remove the **supportedParameters** and **supportedRegions** keys.

### The connector will use a different shared schema

In your **meta.yml** you must specify which schema you use, e.g.

```yml
supportedSchemas:
  input: MinimalModelInput
  output: MinimalModelOutput
```

You should remove the `supportedParameters` and `supportedRegions` keys.
