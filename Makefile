install:
	brew install nginx
	mkdir -p /var/log/nginx
	mkdir -p /var/local-servers/www
	cp static/index.html /var/local-servers/www
	touch private.conf

serve:
	sudo nginx -c $(PWD)/nginx.conf
