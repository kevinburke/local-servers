# installing into var without root causes problems on mac. do not run chown
# /var. lets just install into /usr
nginx_static_folder=/usr/local/local-servers/www

launchdaemons:
	mkdir -p ~/Library/LaunchDaemons

godoc: launchdaemons
	brew install go
	python plist.py go > godoc.plist
	cp godoc.plist ~/Library/LaunchDaemons/com.localservers.godoc.plist
	launchctl load ~/Library/LaunchDaemons/com.localservers.godoc.plist

venv:
	virtualenv venv

python:
	pip install -r requirements.txt --download-cache /tmp/pipcache -i http://pypi.dev.twilio.com/simple

install: venv python godoc
	brew install nginx python
	mkdir -p /var/log/nginx
	mkdir -p $(nginx_static_folder)
	cp static/index.html $(nginx_static_folder)
	touch private.conf

serve:
	# needs to run on port 80, so root
	sudo nginx -c $(PWD)/nginx.conf
