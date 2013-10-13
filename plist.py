import argparse
import subprocess

from jinja2 import Template

GODOC_DEFAULT_PORT = 6060

parser = argparse.ArgumentParser(description='Produce configurable plist files')
parser.add_argument('template', help='The location of the plist template')
parser.add_argument('--port', help='Which port the service should listen on')

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
