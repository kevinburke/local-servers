# installing into var without root causes problems on mac. do not run chown
# /var. lets just install into /usr
nginx_static_folder=/usr/local-servers/www

install:
	brew install nginx
	mkdir -p /var/log/nginx
	mkdir -p /usr/local-servers/www
	cp static/index.html /usr/local-servers/www
	touch private.conf

serve:
	sudo nginx -c $(PWD)/nginx.conf
