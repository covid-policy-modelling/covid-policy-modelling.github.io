# Model Connectors

A model connector acts as the translator between the web interface and a model.
It needs to:

* Translate the inputs supplied by the web interface (provided to the connector as a JSON file) to the inputs used by the model.
* Execute the model.
* Translate the output from the model into the output expected by the web interface (again, as a JSON file).

Connectors are implemented as Docker containers.
Both the input and output have to conform to input or output JSON schema respectively.

For more information on writing a connector for a model, please see:

* Our [tutorial](connector-tutorial/) which explains the basic components of a connector, using an SIR model developed in Python.
* Our more detailed [how-to](connector-howto/) documentation, which explains key considerations that need to be taken into account when writing a connector, and outlines approaches for common scenarios.
