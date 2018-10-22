#!/usr/bin/python


from ansible.module_utils.basic import env_fallback
from ansible.module_utils.basic import AnsibleModule
ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'community'
}

DOCUMENTATION = '''
---
module: my_sample_module

short_description: This is my sample module

version_added: "2.4"

description:
    - "This is my longer description explaining my sample module"

options:
    name:
        description:
            - This is the message to send to the sample module
        required: true
    new:
        description:
            - Control to demo if the result of this module is changed or not
        required: false

extends_documentation_fragment:
    - azure

author:
    - Your Name (@yourhandle)
'''

EXAMPLES = '''
# Pass in a message
- name: Test with a message
  my_new_test_module:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_new_test_module:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_new_test_module:
    name: fail me
'''

RETURN = '''
original_message:
    description: The original name param that was passed in
    type: str
message:
    description: The output message that the sample module generates
'''


class ElasticsearchKeystoreValue(object):

    def __init__(self):

        self.module_arg_spec = dict(
            setting=dict(type='str', required=True, aliases=['name']),
            value=dict(type='str', no_log=True, required=True),
            state=dict(type='str', options=[
                       'present', 'absent'], default='present'),
            allow_override=dict(type='bool', default=False),
            executable=dict(
                type='path', default='/usr/share/elasticsearch/bin/elasticsearch-keystore'),
            configuration_path=dict(
                type='path', default='/etc/elasticsearch', fallback=(env_fallback, ['ES_PATH_CONF']))
        )

        self.module = AnsibleModule(
            argument_spec=self.module_arg_spec,
            supports_check_mode=True,
        )

        self.results = dict(
            changed=False,
        )

        self.setting = ''
        self.value = ''
        self.state = 'present'
        self.allow_override = False
        self.executable = ''
        self.configuration_path = ''

        self.check_mode = self.module.check_mode

        self.run_module(**self.module.params)
        self.module.exit_json(**self.results)

    def run_module(self, **kwargs):

        for key in list(self.module_arg_spec.keys()):
            setattr(self, key, kwargs[key])

        changed = False

        keystore_setting_exists = self.setting in self._list_keystore_values()

        if self.state == 'present':
            if not keystore_setting_exists:
                changed = True

                if not self.check_mode:
                    self._add_keystore_value()

            else:
                if self.allow_override:
                    changed = True

                if not self.check_mode:
                    self._add_keystore_value(force=True)

        else:
            if keystore_setting_exists:
                changed = True

                if not self.check_mode:
                    self._remove_keystore_value()

        self.results['changed'] = changed
        self.results['setting'] = self.setting

    def _list_keystore_values(self):
        list_command_output = self._execute_command(['list'])

        return list_command_output.split('\n')

    def _add_keystore_value(self, force=False):
        args = ['add', '--stdin', self.setting]

        if force:
            args.append('--force')

        self._execute_command(args, data=self.value, use_unsafe_shell=True)

    def _remove_keystore_value(self):

        args = ['remove', self.setting]

        self._execute_command(args, data=self.value, use_unsafe_shell=True)

    def _execute_command(self, args, data=None, use_unsafe_shell=False):

        command_environment = dict(
            ES_PATH_CONF=self.configuration_path,
        )

        command_args = [self.executable]
        command_args.extend(args)

        rc, out, err = self.module.run_command(command_args,
                                               data=data,
                                               use_unsafe_shell=use_unsafe_shell,
                                               environ_update=command_environment)

        if rc != 0:
            self.module.fail_json(
                msg='non-zero return code', err=err, rc=rc)

        return out.rstrip(b"\r\n")


def main():
    ElasticsearchKeystoreValue()


if __name__ == '__main__':
    main()
