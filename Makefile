include .env

IMAGE_NAME=$(REGISTRY)/bireme/api-docs
APP_VERSION?=$(shell git describe --tags --long --always | sed 's/-g[a-z0-9]\{7\}//' | sed 's/-/\./')
TAG_LATEST=$(IMAGE_NAME):latest

COMPOSE_FILE_DEV=docker-compose-dev.yml

## variable used in docker-compose for tag the build image
export IMAGE_TAG=$(IMAGE_NAME):$(APP_VERSION)

tag:
	@echo "IMAGE TAG:" $(IMAGE_TAG)

## docker-compose desenvolvimento
dev_build:
	@docker-compose -f $(COMPOSE_FILE_DEV) build

dev_start:
	@docker-compose -f $(COMPOSE_FILE_DEV) up -d

dev_run:
	@docker-compose -f $(COMPOSE_FILE_DEV) up

dev_logs:
	@docker-compose -f $(COMPOSE_FILE_DEV) logs -f

dev_stop:
	@docker-compose -f $(COMPOSE_FILE_DEV) stop

dev_ps:
	@docker-compose -f $(COMPOSE_FILE_DEV) ps

dev_rm:
	@docker-compose -f $(COMPOSE_FILE_DEV) rm -f

dev_sh:
	@docker-compose -f $(COMPOSE_FILE_DEV) exec api_docs sh


## docker-compose prod
prod_build:
	@docker build . -t $(IMAGE_TAG)
	@docker tag $(IMAGE_TAG) $(TAG_LATEST)

prod_pull_all:
	@echo "$(REGISTRY_PASSWORD)" | docker login $(REGISTRY) --username=$(REGISTRY_USERNAME) --password-stdin
	@docker pull $(IMAGE_NAME) --all-tags

prod_pull_latest:
	@echo "$(REGISTRY_PASSWORD)" | docker login $(REGISTRY) --username=$(REGISTRY_USERNAME) --password-stdin
	@docker pull $(TAG_LATEST)

prod_push:
	@echo "$(REGISTRY_PASSWORD)" | docker login $(REGISTRY) --username=$(REGISTRY_USERNAME) --password-stdin
	@docker push $(IMAGE_NAME) --all-tags

prod_start:
	@docker-compose --compatibility up -d

prod_run:
	@docker-compose --compatibility up

prod_logs:
	@docker-compose --compatibility logs -f

prod_stop:
	@docker-compose --compatibility stop

prod_ps:
	@docker-compose --compatibility ps

prod_rm:
	@docker-compose --compatibility rm -f

prod_list_images:
	@docker images $(IMAGE_NAME}

prod_rollback:
	@echo '*** ROLLBACK TO VERSION $(APP_VERSION) ***'
	@docker-compose --compatibility stop
	@docker-compose --compatibility up -d

prod_exec_shell:
	@docker-compose --compatibility exec api_docs sh

