# installing into var without root causes problems on mac. do not run chown
# /var. lets just install into /usr
nginx_static_folder=/usr/local/local-servers/www

launchctl_folder=~/Library/LaunchDaemons
root_launchctl_folder=/Library/LaunchDaemons
ipython_plist=ipython.plist
nginx_plist=nginx.plist
PYTHON_DOCS=python-2.7.6-docs-html

launchdaemons:
	mkdir -p $(launchctl_folder)

godoc: venv launchdaemons
	brew install go
	. venv/bin/activate; python plist.py go > godoc.plist
	cp godoc.plist $(launchctl_folder)/com.localservers.godoc.plist
	launchctl unload $(launchctl_folder)/com.localservers.godoc.plist
	launchctl load $(launchctl_folder)/com.localservers.godoc.plist

venv:
	virtualenv venv

python:
	rm -rf $(nginx_static_folder)/python
	wget http://docs.python.org/2/archives/$(PYTHON_DOCS).zip -O var/python/$(PYTHON_DOCS).zip -nc || true
	tar -xf var/python/$(PYTHON_DOCS).zip -C var/python
	cp -r var/python/$(PYTHON_DOCS)/ $(nginx_static_folder)/python
	

ipython: venv launchdaemons
	mkdir -p var/log
	. venv/bin/activate; pip install -r requirements.txt --download-cache /tmp/pipcache
	mkdir -p $(HOME)/.ipython_notebooks
	. venv/bin/activate; python plist.py ipython > $(ipython_plist)
	cp $(ipython_plist) $(launchctl_folder)/com.localservers.$(ipython_plist)
	launchctl unload $(launchctl_folder)/com.localservers.$(ipython_plist) || true
	launchctl load $(launchctl_folder)/com.localservers.$(ipython_plist)

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
	sudo launchctl unload $(root_launchctl_folder)/com.localservers.$(nginx_plist) || true
	sudo launchctl load $(root_launchctl_folder)/com.localservers.$(nginx_plist)

clean:
	sudo launchctl unload $(root_launchctl_folder)/com.localservers.$(nginx_plist) || true
	launchctl unload $(launchctl_folder)/com.localservers.$(ipython_plist) || true
	launchctl unload $(launchctl_folder)/com.localservers.godoc.plist
	rm -rf venv

install: venv python ipython godoc nginx

serve:
	# needs to run on port 80, so root
	# You should however install this with "make nginx"
	sudo nginx -c $(PWD)/nginx.conf
