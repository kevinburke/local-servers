.PHONY: devdocs godoc ruby python php

# installing into var without root causes problems on mac. do not run chown
# /var. lets just install into /usr
nginx_static_folder=/usr/local/local-servers/www

launchctl_folder=~/Library/LaunchDaemons
root_launchctl_folder=/Library/LaunchDaemons
ipython_plist=ipython.plist
nginx_plist=nginx.plist

PYTHON_DOCS=python-2.7.6-docs-html

PHP_DOCS=php-chunked-xhtml
PHP_PKG=php_manual_en.tar.gz
RUBY_DOCS=ruby_1_9_3_stdlib
RUBY_PKG=$(RUBY_DOCS)_rdocs.tgz
USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.57 Safari/537.36'

UNAME:=$(shell uname)

launchdaemons:
	mkdir -p $(launchctl_folder)

godoc: venv launchdaemons
	brew install go
	go install code.google.com/p/go.tools/cmd/godoc
	. venv/bin/activate; python plist.py go > godoc.plist
	cp godoc.plist $(launchctl_folder)/com.localservers.godoc.plist
ifeq ($(UNAME), Darwin)
	launchctl unload $(launchctl_folder)/com.localservers.godoc.plist
	launchctl load $(launchctl_folder)/com.localservers.godoc.plist
endif

venv:
	virtualenv venv

ruby:
	rm -rf $(nginx_static_folder)/ruby
	mkdir -p var/ruby
	# Ruby-doc doesn't like wget for some reason.
	wget http://ruby-doc.org/downloads/$(RUBY_PKG) --header "User-Agent: $(USER_AGENT)" --output-document var/ruby/$(RUBY_PKG) -nc || true
	tar -xf var/ruby/$(RUBY_PKG) -C var/ruby
	cp -r var/ruby/$(RUBY_DOCS) $(nginx_static_folder)/ruby
	# Get the CSS to load...
	mkdir -p $(nginx_static_folder)/ruby/css
	cp $(nginx_static_folder)/ruby/stdlib-doc.css $(nginx_static_folder)/ruby/css
	cp $(nginx_static_folder)/ruby/stdlib-doc.css $(nginx_static_folder)/ruby/css
	cp -r $(nginx_static_folder)/ruby/libdoc/uri/rdoc/css/ $(nginx_static_folder)/ruby/css
	cp -r $(nginx_static_folder)/ruby/libdoc/uri/rdoc/js/ $(nginx_static_folder)/ruby/js

python:
	rm -rf $(nginx_static_folder)/python
	mkdir -p var/python
	wget http://docs.python.org/2/archives/$(PYTHON_DOCS).zip --header "User-Agent: $(USER_AGENT)" --output-document var/python/$(PYTHON_DOCS).zip -nc || true
	tar -xf var/python/$(PYTHON_DOCS).zip -C var/python
	cp -r var/python/$(PYTHON_DOCS)/ $(nginx_static_folder)/python

ipython: venv launchdaemons
	mkdir -p var/log
	. venv/bin/activate; pip install -r requirements.txt --download-cache /tmp/pipcache
	mkdir -p $(HOME)/.ipython_notebooks
	. venv/bin/activate; python plist.py ipython > $(ipython_plist)
	cp $(ipython_plist) $(launchctl_folder)/com.localservers.$(ipython_plist)
ifeq ($(UNAME), Darwin)
	launchctl unload $(launchctl_folder)/com.localservers.$(ipython_plist) || true
	launchctl load $(launchctl_folder)/com.localservers.$(ipython_plist)
endif

php:
	mkdir -p var/php
	wget http://www.php.net/get/php_manual_en.tar.gz/from/this/mirror --header "User-Agent: $(USER_AGENT)" --output-document var/php/$(PHP_PKG) -nc || true
	tar -xf var/php/$(PHP_PKG) -C var/php
	cp -r var/php/$(PHP_DOCS) $(nginx_static_folder)/php

nginx:
	brew install nginx
	sudo mkdir -p /var/log/nginx
	sudo /usr/bin/chgrp -R admin /var/log/nginx
	mkdir -p $(nginx_static_folder)
	cp static/index.html $(nginx_static_folder)
	touch private.conf
	. venv/bin/activate; python plist.py nginx > nginx.plist

	# These need to be copied to the root /Library because they run on port 80
	# Enter your password at the prompt:
	sudo cp $(nginx_plist) $(root_launchctl_folder)/com.localservers.$(nginx_plist)
ifeq ($(UNAME), Darwin)
	sudo launchctl unload $(root_launchctl_folder)/com.localservers.$(nginx_plist) || true
	sudo launchctl load $(root_launchctl_folder)/com.localservers.$(nginx_plist)
endif

clean:
ifeq ($(UNAME), Darwin)
	sudo launchctl unload $(root_launchctl_folder)/com.localservers.$(nginx_plist) || true
	launchctl unload $(launchctl_folder)/com.localservers.$(ipython_plist) || true
	launchctl unload $(launchctl_folder)/com.localservers.godoc.plist
endif
	rm -rf venv

install: venv python ipython godoc nginx ruby

serve:
	# needs to run on port 80, so root
	# You should however install this with "make nginx"
	sudo nginx -c $(PWD)/nginx.conf

devdocs:
	if [ ! -d $(PWD)/devdocs ]; then git clone git@github.com:Thibaut/devdocs.git; fi
	cd devdocs && gem install bundler
	cd devdocs && bundle install
	cd devdocs && thor docs:download --all
	cd devdocs && rackup
