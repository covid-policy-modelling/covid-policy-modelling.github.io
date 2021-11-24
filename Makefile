SRC_DIR=diagrams
BUILD_DIR=assets/diagrams

DIAGRAMS_IN=$(wildcard $(SRC_DIR)/*.puml)
DIAGRAMS_OUT=$(patsubst $(SRC_DIR)/%.puml, $(BUILD_DIR)/%.png, $(DIAGRAMS_IN))

.PHONY : all
all : $(DIAGRAMS_OUT)

$(BUILD_DIR)/%.png : $(SRC_DIR)/%.puml
	plantuml -o $(BUILD_DIR) $<

.PHONY : clean
clean :
	rm -f $(BUILD_DIR)/*

.PHONY : info
info :
	@echo SRC_DIR: $(SRC_DIR)
	@echo BUILD_DIR: $(BUILD_DIR)
	@echo DIAGRAMS_IN: $(DIAGRAMS_IN)
	@echo DIAGRAMS_OUT: $(DIAGRAMS_OUT)
