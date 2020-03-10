#!/usr/local/bin/python3.7

# run this on bsd to create keys in dconf

import os
from gi.repository  import Gio

schema_source = Gio.SettingsSchemaSource.new_from_directory(
	# get default schema
    os.path.expanduser("../data"),
    Gio.SettingsSchemaSource.get_default(),
    False,
)
schema = schema_source.lookup('com.github.darkoverlordofdata.catlock', False)
settings = Gio.Settings.new_full(schema, None, None)
settings.set_string('calendar-path',".local/share/orage/orage.ics")

