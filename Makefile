TOP_DIR = ../..
TARGET ?= /kb/deployment
DEPLOY_RUNTIME = /kb/runtime
SERVICE = awe_service
SERVICE_DIR = $(TARGET)/services/$(SERVICE)

GO_TMP_DIR = /tmp/go_build.tmp

AWE_DIR = /mnt/awe

TPAGE_ARGS = --define kb_top=$(TARGET) \
--define site_port=7079 \
--define api_port=7080 \
--define api_ip=140.221.84.186 \
--define site_dir=$(AWE_DIR)/site \
--define data_dir=$(AWE_DIR)/data \
--define logs_dir=$(AWE_DIR)/logs \
--define awfs_dir=$(AWE_DIR)/awfs \
--define mongo_host=localhost \
--define mongo_db=ShockDBtest

include $(TOP_DIR)/tools/Makefile.common

.PHONY : test

all: initialize build-awe

deploy: deploy-libs deploy-client deploy-service

deploy-libs:
	
deploy-client: all
	cp $(BIN_DIR)/awe-client $(TARGET)/bin/awe-client

build-awe: $(BIN_DIR)/awe-server

$(BIN_DIR)/awe-server: AWE/awe-server/awe-server.go
	rm -rf $(GO_TMP_DIR)
	mkdir -p $(GO_TMP_DIR)/src/github.com/MG-RAST
	cp -r AWE $(GO_TMP_DIR)/src/github.com/MG-RAST/
	export GOPATH=$(GO_TMP_DIR); go get -v github.com/MG-RAST/AWE/...
	cp -v $(GO_TMP_DIR)/bin/awe-server $(BIN_DIR)/awe-server
	cp -v $(GO_TMP_DIR)/bin/awe-client $(BIN_DIR)/awe-client

deploy-service: all
	cp $(BIN_DIR)/awe-server $(TARGET)/bin
	$(TPAGE) $(TPAGE_ARGS) awe_server.cfg.tt > awe.cfg
	$(TPAGE) $(TPAGE_ARGS) AWE/site/js/config.js.tt > AWE/site/js/config.js
	mkdir -p $(AWE_DIR)/site $(AWE_DIR)/data $(AWE_DIR)/logs $(AWE_DIR)/awfs
	rm -r $(AWE_DIR)/site
	cp -v -r AWE/site $(AWE_DIR)/site
	mkdir -p $(BIN_DIR) $(SERVICE_DIR) $(SERVICE_DIR)/conf $(SERVICE_DIR)/logs/awe $(SERVICE_DIR)/data/temp
	cp -v awe.cfg $(SERVICE_DIR)/conf/awe.cfg
	cp -r AWE/templates/awf_templates/* $(AWE_DIR)/awfs/
	cp service/start_service $(SERVICE_DIR)/
	chmod +x $(SERVICE_DIR)/start_service
	cp service/stop_service $(SERVICE_DIR)/
	chmod +x $(SERVICE_DIR)/stop_service

initialize: AWE/site

AWE/site:
	git submodule init
	git submodule update
	$(TPAGE) $(TPAGE_ARGS) init/awe.conf.tt > /etc/init/awe.conf
