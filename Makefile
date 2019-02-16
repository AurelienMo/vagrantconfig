EXEC_APACHE        = sudo service apache2
EXEC_PHP        = php

SYMFONY         = $(EXEC_PHP) bin/console
COMPOSER        = composer
NPM            = npm

##
## Project
## -------
##

.DEFAULT_GOAL := help

help: ## Default goal (display the help message)
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-20s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.PHONY: help

##
## Tools
## ------
##
xdebugen: ## Enable Xdebug
	sudo phpenmod xdebug
	$(EXEC_APACHE) restart

xdebugdis: ## Disable Xdebug
	sudo phpdismod xdebug
	$(EXEC_APACHE) restart

cc: ## Clear the cache (by default, the dev env is used)
cc: var/cache
	$(SYMFONY) cache:clear --env=$(or $(ENV), dev)

cw: ## Cache warmup (by default, the dev env is used)
	$(SYMFONY) cache:warmup --env=$(or $(ENV), dev)

cs: ## Run phpcs
cs: vendor/bin/phpcs
	vendor/bin/phpcs --standard=PSR1,PSR2 --ignore=src/AppBundle/Domain/DoctrineMigrations/*,src/DataFixtures/* src/

stan: ## Run phpstan
stan: vendor/bin/phpstan
	vendor/bin/phpstan analyze src

##
## Manage Dependencies
## ------
##

vendor: ## Install composer dependecies
vendor: composer.lock
	$(COMPOSER) install -n --prefer-dist

new-vendor: ## Require new dependency
new-vendor: composer.json
	$(COMPOSER) require $(DEP)

new-dev-vendor: ## Require new dev dependency
new-dev-vendor: composer.json
	$(COMPOSER) require $(DEP) --dev

remove-vendor: ## Remove dependency
remove-vendor: composer.json
	$(COMPOSER) require $(DEP) --dev

node: ## Install npm depencies
node: package.lock
	$(NPM) install

add-node: ##  Add package to dependencies
add-node: package.json
	$(NPM) install $(PACKAGE) --save

dev-node: ## Add package to dev dependencies
dev-node: package.json
	$(NPM) install $(PACKAGE) --save-dev

##
## Database
## ------
##
db-diff: ## Generate doctrine diff
db-diff: src/Entity
	$(SYMFONY) doctrine:migrations:diff

db-migr: ## Execute migration
db-migr: src/Domain/DoctrineMigrations
	$(SYMFONY) doctrine:migrations:migrate -n

db-down: ## Down migration
db-down: src/Domain/DoctrineMigrations
	$(SYMFONY) doctrine:migrations:exec --down $(VERSION) -n

db-up: ## Up migration
db-up: src/Domain/DoctrineMigrations
	$(SYMFONY) doctrine:migrations:exec --up $(VERSION) -n

##
## TESTS
## ------
##
tu: ## Run phpunit
tu: tests
	vendor/bin/phpunit
tf: ## Run behat
tf: features
	vendor/bin/behat --stop-on-failure
