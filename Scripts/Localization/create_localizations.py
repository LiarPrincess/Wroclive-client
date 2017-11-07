# -*- coding: utf-8 -*-

import os
import sys
import re
import json
import collections

# ========
# = init =
# ========

# set default encoding to utf-8 as we are dealing with polish characters and python 2.7
reload(sys)
sys.setdefaultencoding('utf-8')

localization_directory = os.path.join(os.getcwd(), 'Sources', 'App')
localization_line_pattern = re.compile('"(.*)"\W* = "(.*)";')
localization_separator = '_'

base_language = 'en'
languages = ['Base', 'pl']

indentation = '  '

# ===========
# = helpers =
# ===========

def read_localization_file(language):
    """Read localization file for given @language and return [key, translation] dictionary."""

    filepath = os.path.join(localization_directory, language + '.lproj', 'Localizable.strings')

    result = {}
    with open(filepath) as f:
        for line in f:
            localization_line = re.match(localization_line_pattern, line.strip())
            if localization_line:
                key = localization_line.group(1)
                translation = localization_line.group(2)
                result[key] = { language: translation }
    return result

def merge_dictionaries(lhs, rhs):
    """Source: https://stackoverflow.com/a/7205234"""

    result = {}
    for item, value in lhs.iteritems():
        if rhs.has_key(item):
            if isinstance(rhs[item], dict):
                result[item] = merge_dictionaries(value, rhs.pop(item))
        else:
            result[item] = value
    for item, value in rhs.iteritems():
        result[item] = value
    return result

def validate(localization_values):
    """Check if all translations were provided in all of the languages."""

    is_missing_key = False
    for (key, translations) in localization_values.items():
        if len(translations) != len(languages):
            is_missing_key = True
            print 'Incomplete translations for: \'' + key + '\'!'

    if is_missing_key:
        sys.exit(0)

def group_by_keys(localization_values):
    """Split keys of @localization_values using @localization_separator to create tree hierarchy"""

    result = {}
    for (key, localizations) in localization_values.items():
        key_split = key.split(localization_separator)

        current_node = result
        for node in key_split[:-1]:
            if not current_node.has_key(node):
                current_node[node] = {}
            current_node = current_node[node]

        property_name = key_split[-1]
        property_name = property_name[0].lower() + property_name[1:]
        current_node[property_name] = { 'property_flag': True, 'key': key, 'values': localizations }
    return result

def generate_code(dictionary, level = 0):
    """Print Swift code."""

    dictionary = collections.OrderedDict(sorted(dictionary.items()))
    for key, value in dictionary.items():
        indent = indentation * level
        is_property = value.has_key('property_flag')

        print('')
        if is_property:
            localization_key = value['key']
            localization_values = value['values']
            base_localization = localization_values['Base']

            print(indent + '/// ' + base_localization)
            for (language, value) in localization_values.items():
                language = base_language if language == 'Base' else language
                print(indent + '/// - **' + str(language) + '**: ' + value)

            # static var cardTitle: String { return localizedString("Search_CardTitle") }
            print(indent + 'static var ' + key + ': String { return localizedString("' + localization_key + '") }')
        else:
            print(indent + 'struct ' + str(key) + ' {')
            generate_code(value, level + 1)
            print(indent + '}')

def debug_print(dictionary):
    print json.dumps(dictionary, sort_keys = True, indent = 4)

# ========
# = main =
# ========

localization_values = {}

for language in languages:
    values = read_localization_file(language)
    localization_values = merge_dictionaries(localization_values, values)

validate(localization_values)

print '//'
print '//  Created by Michal Matuszczyk'
print '//  Copyright © 2017 Michal Matuszczyk. All rights reserved.'
print '//'
print ''
print '//======================================================================='
print '//'
print '// This file is computer generated from Localizable.strings. Do not edit.'
print '//'
print '//======================================================================='
print ''
print '// swiftlint:disable valid_docs'
print '// swiftlint:disable line_length'
print '// swiftlint:disable file_length'
print ''
print 'public struct Localizable {'

generate_code(group_by_keys(localization_values), 1)

print '}'
