workspace {

    model {
        models = softwareSystem "Models"
        github = softwareSystem "GitHub" "GitHub API/Actions/Login/Packages" "Summary"
        group "GitHub" {
            githubLogin = softwareSystem "GitHub Login" "Authentication via GitHub website login" "Detail"
            githubActions = softwareSystem "GitHub Actions" "Execute simulations" "Detail"
            githubApi = softwareSystem "GitHub API" "Communication with GitHub Actions" "Detail" {
                -> githubActions "Triggers event"
            }
            githubPackages = softwareSystem "GitHub Packages / Container Registry" "Stores model code" "Detail" {
                -> models "Incorporates"
            }
        }

        enterprise "Covid Policy Modelling" {
            webInterface = softwareSystem "Web Interface" "Allows policy makers to schedule simulations and compare what different models predict" {
                database = container "Database" "Details of simulations"
                blobStore = container "Object store" "Outputs of simulations"
                webApi = container "API" "Schedules simulations and returns results via JSON" {
                    -> github "Schedules simulation"
                    -> githubLogin "Checks tokens"
                    -> githubApi "Schedules simulation"
                    -> database "Updates and queries"
                    -> blobStore "Queries"
                }
                webUi = container "UI" "Allows policy makers to schedule simulations and compare what different models predict" {
                    -> webApi "Uses"
                }
            }
            jobRunner = softwareSystem "Job Runner" "Interprets parameters and executes simulations" {
                modelConnector = container "Model Connector" "Converts parameters to model-specific parameters and executes simulation" {
                    -> models "Uses"
                }
                modelRunnerC = container "Model Runner" "Spawns other containers to execute simulation" {
                    -> githubPackages "Fetches model containers"
                    -> modelConnector "Executes"
                    -> blobStore "Updates simulation outputs"
                    -> webApi "Updates simulations details"
                }
                actionsRunner = container "Actions Runner" "Executes jobs from GitHub Actions" {
                    -> modelRunnerC "Creates"
                }
                actionsRunnerController = container "Actions Runner Controller" "Fetches jobs from GitHub Actions" {
                    -> actionsRunner "Creates"
                    -> github "Fetches simulation jobs"
                    -> githubActions "Fetches simulation jobs"
                }
            }
            controlPlane = softwareSystem "Control Plane" {
                -> modelRunnerC "Defines jobs"
            }
            github -> controlPlane "Fetches workflow definition"
            githubActions -> controlPlane "Fetches workflow definition"
        }

        policyMaker = person "Policy Maker" "A non-expert user" {
            -> githubLogin "Authenticates"
            -> webUi "Sets up simulation"
        }
        researcher = person "Researcher" "An expert user" "Detail" {
            -> githubLogin "Authenticates"
            -> webApi "Sets up simulation"
        }
        modelDeveloper = person "Model Developer" "A model developer" {
            -> models "Develops models"
        }

        production = deploymentEnvironment "Production" {
            deploymentNode "Browser" {
                containerInstance webUi
            }
            deploymentNode "Azure" {
                deploymentNode "Azure Container Instance" {
                    containerInstance webApi
                }
                deploymentNode "Azure Kubernetes Service" {
                    deploymentNode "Default Node Pool" {
                        deploymentNode "Node (x1)" {
                            deploymentNode "pod (x1)" {
                                containerInstance actionsRunnerController
                            }
                        }
                    }
                    deploymentNode "Standard Node Pool" {
                        deploymentNode "Node (x0-6)" {
                            deploymentNode "pod (x0-18)" {
                                containerInstance actionsRunner
                                containerInstance modelRunnerC
                                containerInstance modelConnector
                            }
                        }
                    }
                }
                deploymentNode "Azure Database" {
                    containerInstance database
                }
                deploymentNode "Azure Object Store" {
                    containerInstance blobStore
                }
            }
            deploymentNode "GitHub" {
                softwareSystemInstance controlPlane
            }
        }
    }

    views {
        systemLandscape {
            include *
            exclude "element.tag==Summary"
        }
        systemLandscape SystemLandscapeSummary {
            include *
            exclude "element.tag==Detail"
        }
        systemContext controlPlane {
            include *
            exclude "element.tag==Summary"
        }
        container jobRunner {
            include *
            exclude "element.tag==Summary"
        }
        container webInterface {
            include *
            exclude "element.tag==Summary"
        }
        deployment * production {
            include *
        }
    }
}
