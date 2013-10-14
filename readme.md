# Local server redirect

This sets up a series of tasks to run at system startup, as well as an nginx
server that can serve things at a given host.

## Why should I use this?

After you run this, you can go to `http://godoc` to get a Go documentation
browser, or `http://ipython` to get the iPython notebook. All your iPython
notebooks will be saved in `.ipython_notebooks`.

## Install

Run the following at the command line:

    make install

This will:

1. Generate usable `.plist` files for your machine for `godoc` and
   `ipython`

2. Copy them to LaunchDaemons

3. Install them with launchctl, so they load when your machine boots.
