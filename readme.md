# Local server redirect

This sets up a series of tasks to run at system startup, as well as an nginx
server that can serve things at a given host. Ever get on a plane and **then**
realize you should have made the docs locally? This project does that for you.

## What can I do with it?

- View the Python docs by going to "http://python"

- View the Ruby docs by going to "http://ruby"

- View Golang docs by going to "http://godoc"

- Open IPython by going to "http://ipython"

And more! Add anything you want to `private.conf` to add this porject.

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
