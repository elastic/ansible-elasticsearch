#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2016, simplesurance GmbH, Sirk Johannsen <sirk.hjohannsen@simplesurance.de>
#
# This file extends Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>


import subprocess
import shlex
import os

DOCUMENTATION = '''
This module gives access to the elasticsearch "plugin" functionality and allows installing and uninstalling of plugins
'''
EXAMPLES = '''
 - name: Install elasticsearch Marvel Plugins
   elasticsearch_plugin: plugin={{ item }} state=present
   with_items:
     - 'license'
     - 'marvel-agent'

'''

RETURN = '''
returns 
 success: True/False
 returncode: Returncode of the shell command
 output: stdout and stderr
 command: The execured command
'''

def main():
  module = AnsibleModule(
    argument_spec = dict(
      plugin   = dict(required=True),
      name     = dict(default=None),
      version  = dict(default=None),
      state    = dict(default="present", options=['present', 'absent']),
      es_home  = dict(default="/usr/share/elasticsearch"),
      conf_dir = dict(default="/etc/elasticsearch"),
      instance_default_file = dict(default="/etc/default/elasticsearch"),
    ),
    supports_check_mode = True,
  )
  
  params = module.params

  #Set Env for shell commands
  my_env = os.environ.copy() 
  my_env["ES_HOME"] = params["es_home"]
  my_env["ES_INCLUDE"] = params["instance_default_file"]
  my_env["CONF_DIR"] = params["conf_dir"]

  # Should come from {{ es_home }} !!!!
  escmd = params["es_home"] + "/bin/plugin"

  # Set defaults
  pchanged = False
  psuccess = True

  # Check if plugin is installed
  #  Deal with plugins that contain a logner "path"
  parts = params['plugin'].split("/")
  if len(parts) > 1:
    if params['name'] is not None:
      plugin_short = params['name']
    else:
      plugin_short = parts[1]
  else:
    plugin_short = params['plugin'].strip()
  rcommand = escmd + " list | grep -- '- " + plugin_short + "$'"
  checkcmd = subprocess.Popen(rcommand, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=my_env)
  checkresult = checkcmd.communicate()
  preturn = checkcmd.returncode
  pstdout = checkresult[0] + " : " + checkresult[1]
  if checkcmd.returncode == 0:
    plugin_state = "present"
  else:
    plugin_state = "absent"

  # Achieve the desired state
  if plugin_state != params['state']:
    if params['state'] == "present":
      action = " install"
      if params['version'] is not None and params['version'] != '':
        plugin = params['plugin'] + "/" + params['version']
      else:
        plugin = params['plugin']
    else:
      action = " remove"
      plugin = plugin_short
    rcommand = escmd + action + " " + plugin
    fcmd = subprocess.Popen(rcommand, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=my_env)
    presult = fcmd.communicate()
    preturn = fcmd.returncode
    pstdout = presult[0] + " : " + presult[1]
    if fcmd.returncode != 0 :
      psuccess = False
    else :
      pchanged = True

  if psuccess :
    module.exit_json(changed=pchanged, success=psuccess, returncode=preturn, output=pstdout, command=rcommand)
  else :
    module.fail_json(msg=pstdout)

# import module snippets
from ansible.module_utils.basic import *
main()
