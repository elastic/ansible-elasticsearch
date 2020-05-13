#!/usr/bin/env python3
import fileinput
import os

"""
This script is used to bump elasticsearch versions before a new release

Usage:
- Change the values of `old_versions` and `new_versions``
- Run the script: `./bumper.py`
- That's all
"""

os.chdir(os.path.join(os.path.dirname(__file__), '..'))

old_versions = {
    6: '6.8.8',
    7: '7.6.2',
}

new_versions = {
    6: '6.8.9',
    7: '7.7.0',
}

files = [
    'README.md',
    'defaults/main.yml',
    '.kitchen.yml',
]

for major, version in old_versions.items():
    for file in files:
        print(file)
        for line in fileinput.input([file], inplace=True):
            print(line.replace(version, new_versions[major]), end='')
