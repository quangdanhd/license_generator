COLOUR_GREEN=\033[0;32m
COLOUR_RED=\033[0;31m
COLOUR_YEllOW=\033[0;33m
COLOUR_BLUE=\033[0;34m
COLOUR_END=\033[0m

##@ General
.DEFAULT_GOAL := help
.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
##@ Format
c: ## prettier check
	prettier --check .
w: ## prettier write
	prettier --write .
##@ License
key: ## create license
	@printf "$(COLOUR_GREEN)What application do you want to create a license for?$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)1: Upwork Helper$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)Enter the number then press enter to continue.$(COLOUR_END)\n" && \
	read ans && \
	if [ $${ans:-'N'} = '1' ]; then \
		make license-type project=upwork-helper; \
	elif [ $${ans:-'N'} = '2' ]; then \
		echo 2; \
	elif [ $${ans:-'N'} = '3' ]; then \
		echo 3; \
	elif [ $${ans:-'N'} = 'N' ]; then \
		printf "$(COLOUR_GREEN)exit$(COLOUR_END)\n"; \
	else \
		printf "$(COLOUR_GREEN)exit$(COLOUR_END)\n"; \
	fi
license-type:
	@printf "$(COLOUR_GREEN)Select license type:$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)1: One week$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)2: One month$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)3: Six months$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)4: One year$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)5: Lifetime$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$(COLOUR_END)\n" && \
	printf "$(COLOUR_GREEN)Enter the number then press enter to continue.$(COLOUR_END)\n" && \
	read ans && \
	if [ $${ans:-'N'} = '1' ]; then \
		make create-license project=$(project) type=one-week; \
	elif [ $${ans:-'N'} = '2' ]; then \
		make create-license project=$(project) type=one-month; \
	elif [ $${ans:-'N'} = '3' ]; then \
		make create-license project=$(project) type=six-months; \
	elif [ $${ans:-'N'} = '4' ]; then \
    	make create-license project=$(project) type=one-year; \
	elif [ $${ans:-'N'} = '5' ]; then \
    	make create-license project=$(project) type=lifetime; \
	elif [ $${ans:-'N'} = 'N' ]; then \
		printf "$(COLOUR_GREEN)exit$(COLOUR_END)\n"; \
	else \
		printf "$(COLOUR_GREEN)exit$(COLOUR_END)\n"; \
	fi
create-license:
	node license.js --project=$(project) --type=$(type)