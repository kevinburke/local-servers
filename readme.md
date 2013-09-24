# local redirect

usage:

    sudo nginx -c $PWD/nginx.conf   # or append "-s reload"

<a id="install"></a>

## install

Run the following at the command line:

    sed -i.bak s/\/Users\/kevin\/code\/local-redirect/YOUR_FILE_LOCATION/g nginx.conf
    brew install nginx
    sudo echo "127.0.0.1 stash" >> /etc/hosts
    sudo echo "127.0.0.1 jira" >> /etc/hosts
    sudo echo "127.0.0.1 t" >> /etc/hosts

