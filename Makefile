EXEC_APACHE        = sudo service apache2
EXEC_PHP        = php

SYMFONY         = $(EXEC_PHP) bin/console
COMPOSER        = composer
NPM            = npm

##
## Project
## -------
##

## Main
xdebugen: # Enable Xdebug
	sudo phpenmod xdebug
	$(EXEC_APACHE) restart

xdebugdis: # Disable Xdebug
	sudo phpdismod xdebug
	$(EXEC_APACHE) restart

# Doctrine
migration-diff: # Generate doctrine diff
	$(SYMFONY) doctrine:migrations:diff

migration-migr: # Execute migration
	$(SYMFONY) doctrine:migrations:migrate -n

migration-down: # Down migration
	$(SYMFONY) doctrine:migrations:exec --down $(VERSION) -n

migration-up: # Up migration
	$(SYMFONY) doctrine:migrations:exec --up $(VERSION) -n

# NPM
npm-install: # Install npm depencies
	$(NPM) install

npm-add: # Add package to dependencies
	$(NPM) install $(PACKAGE) --save

npm-dev: # Add package to dev dependecies
	$(NPM) install $(PACKAGE) --save-dev

# Symfony Commands
cache-clear: # Cache clear
	$(SYMFONY) cache:clear --env=$(ENV)

cache-warmup: # Cache warmup
	$(SYMFONY) cache:warmup --env=$(ENV)

# Composer composer
dump-a-o: # Dump autoload with optimization
	$(COMPOSER) dump-autoload -o -a

dump-a: # Dump autoload without optimization
	$(COMPOSER) dump-autoload

composer-i: # Install composer dependecies
	$(COMPOSER) install

composer-req: # Require new dependencie
	$(COMPOSER) req $(DEP)

composer-req-dev: # Require new dev dependencie
	$(COMPOSER) req --dev $(DEP)

composer-rem: # Remove dependencie
	$(COMPOSER) remove $(DEP)

# TOOLS
phpcs: # Run phpcs
	vendor/bin/phpcs --standard=PSR1,PSR2 --ignore=src/AppBundle/Domain/DoctrineMigrations/*,src/DataFixtures/* src/
phpstan: # Run phpstan
	vendor/bin/phpstan analyze src

# TESTS
phpunit: # Run phpunit
	vendor/bin/phpunit
behat: # Run behat
	vendor/bin/behat --stop-on-failure
