SHELL=/bin/bash
VENV_NAME := $(shell [ -d venv ] && echo venv || echo .venv)
VENV_DIR=${VENV_NAME}
PYTHON=$(shell if [ -d $(VENV_DIR) ]; then echo $(VENV_DIR)/bin/python; else echo python; fi)


ifneq (,$(findstring xterm,${TERM}))
	BOLD         := $(shell tput -Txterm bold)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	NORMAL := $(shell tput -Txterm sgr0)
endif

update-venv:
	@echo "${BOLD}${YELLOW}update venv:${NORMAL}"
	pip install -U pip
	pip install -U -r requirements.txt

install:
	@echo "${BOLD}${YELLOW}install airflow:${NORMAL}"
	pip install -U pip
	pip install -r requirements.txt
	export AIRFLOW_HOME=$(pwd)
	mkdir dags
	airflow db migrate
	airflow users create --username admin --firstname admin --lastname admin --role Admin --email admin@example.local
	airflow providers list

run-webserver:
	export AIRFLOW_HOME=$(pwd)
	airflow webserver

run-scheduler:
	export AIRFLOW_HOME=$(pwd)
	airflow scheduler
