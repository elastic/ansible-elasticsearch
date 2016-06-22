__author__ = 'dale mcdiarmid'

import re

def modify_list(values=[], pattern='', replacement='', ignorecase=False):
    ''' Perform a `re.sub` on every item in the list'''
    if ignorecase:
        flags = re.I
    else:
        flags = 0
    _re = re.compile(pattern, flags=flags)
    return [_re.sub(replacement, value) for value in values]

def append_to_list(values=[], suffix=''):
    if isinstance(values, basestring):
        values = values.split(',')
    return [str(value+suffix) for value in values]

def array_to_str(values=[],separator=','):
    return separator.join(values)

def parse_plugin_repo(string):
    elements = string.split("/")
    ''' We first consider the simplest form: pluginname'''
    repo = elements[0]
    
    '''We consider the form: username/pluginname'''
    if len(elements) > 1:
        repo = elements[1]
    '''
    remove elasticsearch- prefix
    remove es- prefix
    '''
    for string in ("elasticsearch-", "es-"):
        if repo.startswith(string):
            return repo[len(string):]
    return repo

class FilterModule(object):
    def filters(self):
        return {
            'modify_list': modify_list,
            'append_to_list': append_to_list,
            'array_to_str': array_to_str,
            'parse_plugin_repo': parse_plugin_repo
        }