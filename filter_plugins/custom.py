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

class FilterModule(object):
    def filters(self):
        return {'modify_list': modify_list,
        'append_to_list':append_to_list,
        'array_to_str':array_to_str}