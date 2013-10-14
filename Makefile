# installing into var without root causes problems on mac. do not run chown
# /var. lets just install into /usr
nginx_static_folder=/usr/local/local-servers/www

launchctl_folder="~/Library/LaunchDaemons"

launchdaemons:
	mkdir -p $(launchctl_folder)

godoc: launchdaemons
	brew install go
	python plist.py go > godoc.plist
	cp godoc.plist $(launchctl_folder)/com.localservers.godoc.plist
	launchctl load $(launchctl_folder)/com.localservers.godoc.plist

venv:
	virtualenv venv

python:
	pip install -r requirements.txt --download-cache /tmp/pipcache

nginx:
	brew install nginx
	mkdir -p /var/log/nginx
	mkdir -p $(nginx_static_folder)
	cp static/index.html $(nginx_static_folder)
	touch private.conf
	python plist.py nginx > nginx.plist

install: venv python godoc nginx

serve:
	# needs to run on port 80, so root
	sudo nginx -c $(PWD)/nginx.conf
