# Local server redirect

This sets up a series of tasks to run at system startup, as well as an nginx
server that can serve things at a given host.

## Why should I use this?

After you run this, you can go to `http://godoc` to get a Go documentation
browser, or `http://ipython` to get the iPython notebook. All your iPython
notebooks will be saved in `.ipython_notebooks`.

## Screenshots

Behold:

<img src="https://api.monosnap.com/image/download?id=JsazKxeS0Ml0Te8WHsIhsWuG7"
    alt="iPython, with a named server!" />

<img src="https://api.monosnap.com/image/download?id=4sZ8HJxqW5SjXABqtFqLN36SY"
    alt="Godoc, in your browser!" />

## Install

Run the following at the command line:

    make install

This will:

1. Generate usable `.plist` files for your machine for `godoc` and
   `ipython`

2. Copy them to LaunchDaemons

3. Install them with launchctl, so they load when your machine boots.

4. Start an nginx server that serves those pages at `http://ipython` and
   `http://godoc`

5. Load that nginx server with launchctl.
