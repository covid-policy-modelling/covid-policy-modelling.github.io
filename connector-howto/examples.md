# COVID Policy Modelling Model Connector How-To

This section can guide you to examples of existing connectors, which can be useful as a reference for how to approach specific issues.

|                                                                                                                             | Execution   | Separate repository | Installed | Deployed               | Language    | Hosted | Public | Schemas          | Validation | Data       |
| [basel-connector](https://github.com/covid-policy-modelling/basel-connector)                                                | Application | Yes                 | Container | covid-policy-modelling | Node.js     | GitHub | Yes    | Common           | No         | Container  |
| [covasim-connector](https://github.com/covid-policy-modelling/covasim-connector)                                            | Library     | Yes                 | Package   | covid-policy-modelling | Python      | GitHub | No     | Common           | No         | Container  |
| [covid-sim-connector](https://github.com/covid-policy-modelling/covid-sim-connector)                                        | Application | Yes                 | Container | covid-policy-modelling | Node.js     | GitHub | Yes    | Common           | No         | Container  |
| [MicroMoB-connector](https://github.com/dd-harp/MicroMoB-connector)                                                         | Library     | Yes                 | Package   | covid-policy-modelling | R           | GitHub | Yes    | Custom           | Yes        | Input only |
| [modeling-covid](https://github.com/covid-policy-modelling/model-runner/tree/api/v0.10.0/packages/modelingcovid-covidmodel) | Library     | Yes                 | Container | No                     | Mathematica | GitHub | Yes    | Common           | No         | Container  |
| [sir-ode-python-connector](https://github.com/covid-policy-modelling/sir-ode-python-connector)                              | Library     | No                  | N/A       | covid-policy-modelling | Python      | GitHub | Yes    | Shared (Minimal) | Yes        | Input only |
| [WSS](https://github.com/gjackland/WSS)                                                                                     | Library     | No                  | N/A       | covid-policy-modelling | R           | GitHub | Yes    | Common           | No         | Runtime    |

For reference, our documentation covers the following scenarios:

|                                              | Execution            | Separate repository | Installed                             | Deployed               | Language | Hosted | Public | Schemas          | Validation | Data |
| [Connector Tutorial](../connector-tutorial/) | Library              | No                  | N/A                                   | N/A                    | Python   | GitHub | No     | Shared (Minimal) | Yes        | N/A  |
| [Connector How-To](build.md)                 | Library, Application | Yes                 | Container,Package,External,Repository | covid-policy-modelling | N/A      | GitHub | Yes    | Common           | Yes        | N/A  |
