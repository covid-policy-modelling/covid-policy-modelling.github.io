SRC_DIR=diagrams
BUILD_DIR=assets/diagrams

.PHONY : all
all : $(addprefix $(BUILD_DIR)/structurizr-, SystemLandscape.png SystemLandscapeSummary.png ControlPlane-SystemContext.png JobRunner-Container.png WebInterface-Container.png Production-Deployment.png simulationSummary.png simulationDetail.png simulationDetail-sequence.png)

$(SRC_DIR)/structurizr-simulationDetail-sequence.puml : $(SRC_DIR)/workspace.dsl
	docker run --rm -v $(abspath $(dir $<)):/usr/local/structurizr structurizr/cli export -workspace $(notdir $<) -format plantuml

$(SRC_DIR)/%.puml : $(SRC_DIR)/workspace.dsl
	docker run --rm -v $(abspath $(dir $<)):/usr/local/structurizr structurizr/cli export -workspace $(notdir $<) -format plantuml/c4plantuml

$(BUILD_DIR)/%.png : $(SRC_DIR)/%.puml
	docker run --rm -v $(abspath $(BUILD_DIR)):/output -v $(abspath $(dir $<)):/input dstockhammer/plantuml:1.2022.4 -o /output /input/$(notdir $<)

.PHONY : clean
clean :
	rm -f $(SRC_DIR)/*.puml
	rm -f $(BUILD_DIR)/*
