# Architecture

The main components are:

* **Web Interface** (available in the [web-ui](https://github.com/covid-policy-modelling/web-ui) repository) - this is the main access point available which allows for simulations to be scheduled and once these are run to display the results.
* The **Web Interface** will trigger the **Action Runner** (available in the [action-runner](https://github.com/covid-policy-modelling/actions-runner) repository), using GitHub actions, which will deploy a **Model Runner** via a docker engine.
* The **Model Runner** ( see the [model-runner](https://github.com/covid-policy-modelling/model-runner) repository) which will spawn containers (using Microsoft Azure) to run the simulations. Once these are complete it will communicate the results back to the **Web interface**.
* A **Model Connector** (see the [model-connector-template](https://github.com/covid-policy-modelling/model-connector-template) repository) is used to interface between the outputs of the **Web Interface** expressed in JSON and the output from the models that are consumed by the **Web Interface**, both of these must conform to a set of [JSON input and output schema](https://github.com/covid-policy-modelling/model-runner/tree/main/packages/api/schema).


