
CXX_VERSION := 12
ROOT_DIR:=.#$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
WORKING_DIR := $(ROOT_DIR)/intermediate
SOURCE_DIR := $(ROOT_DIR)/src
BINARY_DIR := $(ROOT_DIR)/bin
OUTPUT_NAME := module-example

OUTPUT := $(BINARY_DIR)/$(OUTPUT_NAME)

CXXFLAGS_LEGACY := -Wall -od -std=c++20
CXXFLAGS := $(CXXFLAGS_LEGACY) -fmodules-ts
CXX := g++-$(CXX_VERSION)

# modules to include
SYSTEM_MODULES := iostream string

# bit of a hack to track sys module builds because i dont know how to set the module cache output path with gcc
GCM_CACHE_ROOT := $(ROOT_DIR)/gcm.cache
GCM_CACHE_PATH := $(GCM_CACHE_ROOT)/usr/include/c++/$(CXX_VERSION)
SYS_MODULE_GCM := $(patsubst %, $(GCM_CACHE_PATH)/%.gcm, $(SYSTEM_MODULES))

.PHONY: clean modules legacy


modules: $(BINARY_DIR) $(WORKING_DIR) $(SYS_MODULE_GCM)
	$(CXX) $(CXXFLAGS) -c $(SOURCE_DIR)/logger.cpp
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -c $(SOURCE_DIR)/logger.cpp -o $(WORKING_DIR)/logger.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -c $(SOURCE_DIR)/main.cpp -o $(WORKING_DIR)/main.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(WORKING_DIR)/logger.o $(WORKING_DIR)/main.o -o $(OUTPUT)_module

legacy: $(BINARY_DIR) $(WORKING_DIR) $(SYS_MODULE_GCM)
	$(CXX) $(CXXFLAGS_LEGACY) $(LDFLAGS) -c $(SOURCE_DIR)/logger_legacy.cpp -o $(WORKING_DIR)/logger_legacy.o
	$(CXX) $(CXXFLAGS_LEGACY) $(LDFLAGS) -c $(SOURCE_DIR)/main_legacy.cpp -o $(WORKING_DIR)/main_legacy.o
	$(CXX) $(CXXFLAGS_LEGACY) $(LDFLAGS) $(WORKING_DIR)/logger_legacy.o $(WORKING_DIR)/main_legacy.o -o $(OUTPUT)_legacy
	
clean:
	@echo cleaning $(GCM_CACHE_ROOT)
	@rm -d -r -f $(GCM_CACHE_ROOT)
	@echo cleaning $(WORKING_DIR)
	@rm -d -r -f $(WORKING_DIR)
	@echo cleaning $(BINARY_DIR)
	@rm -d -r -f $(BINARY_DIR)
	@rm -f d
	@echo done
		
$(SYS_MODULE_GCM): 
	@echo building system module: $(basename $(@F))
	@$(CXX) $(CXXFLAGS) -xc++-system-header $(basename $(@F))
   
$(WORKING_DIR):
	@echo creating $(WORKING_DIR)
	@mkdir -p $(WORKING_DIR)

$(BINARY_DIR):
	@echo creating $(BINARY_DIR)
	@mkdir -p $(BINARY_DIR)
