SRC_DIR=diagrams
BUILD_DIR=assets/diagrams

.PHONY : all
all : $(addprefix $(BUILD_DIR)/structurizr-, SystemLandscape.png SystemLandscapeSummary.png ControlPlane-SystemContext.png ModelRunner-Container.png WebInterface-Container.png Production-Deployment.png)

$(SRC_DIR)/%.puml : $(SRC_DIR)/workspace.dsl
	docker run -it --rm -v $(abspath $(dir $<)):/usr/local/structurizr structurizr/cli export -workspace $(notdir $<) -format plantuml/c4plantuml

$(BUILD_DIR)/%.png : $(SRC_DIR)/%.puml
	plantuml -o $(abspath $(BUILD_DIR)) $<

.PHONY : clean
clean :
	rm -f $(SRC_DIR)/*.puml
	rm -f $(BUILD_DIR)/*
