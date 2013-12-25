import argparse
import os
import subprocess

from jinja2 import Template

GODOC_DEFAULT_PORT = 6061

parser = argparse.ArgumentParser(description='Produce configurable plist files')
parser.add_argument('template', help='The location of the plist template')
parser.add_argument('--port', help='Which port the service should listen on')

current_directory = os.path.dirname(os.path.abspath(__file__))

args = parser.parse_args()
if args.template == "go":
    port = args.port or GODOC_DEFAULT_PORT
    template = Template(open('templates/godoc.plist.template').read())
    try:
        godoc_binary = subprocess.check_output(["which", "godoc"]).strip()
    except subprocess.CalledProcessError as e:
        print "\nCould not find godoc on path! Install godoc to use the godoc server\n"
        raise
    print template.render(godoc_binary=godoc_binary, godoc_port=port)

if args.template == "nginx":
    try:
        nginx_binary = subprocess.check_output(["which", "nginx"]).strip()
    except subprocess.CalledProcessError as e:
        print "\nCould not find godoc on path! Install godoc to use the godoc server\n"
        raise
    template = Template(open('templates/nginx.plist.template').read())
    print template.render(nginx_binary=nginx_binary,
                          current_directory=current_directory)

if args.template == "ipython":
    home = subprocess.check_output("echo $HOME", shell=True).strip()
    template = Template(open('templates/ipython.plist.template').read())
    print template.render(home=home, current_directory=current_directory)

if args.template == "devdocs":
    #try:
        #rubby = subprocess.check_output(["which", "rvm"])
    #except subprocess.CalledProcessError:
        #pass
    devdocs_dir = "{cur}/usr/devdocs/devdocs-master".format(cur=current_directory)
    rackup_binary = subprocess.check_output(["which", "ddocs_rackup"],
                                            cwd=devdocs_dir).strip()
    template = Template(open('templates/devdocs.plist.template').read())
    print template.render(current_directory=current_directory,
                          rackup_binary=rackup_binary)
