# project name and programming language
project('com.github.darkoverlordofdata.catlock', ['vala', 'c'], version: '0.0.3')


# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Add vapi files
add_project_arguments(
  [
    '--vapidir',
    join_paths(meson.current_source_dir(), 'vapi')
  ],
  language: 'vala'
)

# Set configuration data
conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('PREFIX', get_option('prefix'))
conf.set_quoted('VERSION', meson.project_version())
conf.set_quoted('PACKAGE', meson.project_name())
conf.set_quoted('LOCALE_DIR', join_paths(get_option('prefix'), get_option('localedir')))
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('PKG_DATADIR', join_paths(get_option('prefix'), get_option('datadir'), meson.project_name()))
conf.set('BUFLEN', '256')

configure_file(
  output: 'config.h',
  configuration: conf
)

subdir('data')
subdir('po')

# Create a new executable
executable(
    meson.project_name(),
    'src/CatLock.vala',
    'src/Parameters.vala',
    'src/MainWindow.vala',
    # 'src/Display.vala',
    # 'src/Panel.vala',
    'src/calendar/Calendar.vala',
    'src/calendar/CalendarNode.vala',
    'src/calendar/Event.vala',
    'src/calendar/Holidays.vala',
    'src/calendar/Rule.vala',

    import('gnome').compile_resources(
        'as-resources', join_paths('data', meson.project_name() + '.gresource.xml'),
        source_dir: 'data',
        c_name: 'as'
    ),
    c_args: [
      '-include', 'config.h',
      '-I/usr/local/include/freetype2',
      '-I/usr/include/freetype2', # added for Fedora 33-Mate
      '-w', 
      '-DGETTEXT_PACKAGE="' + meson.project_name() + '"'
    ],
    vala_args: [
        meson.source_root() + '/vapi/config.vapi',
        meson.source_root() + '/vapi/x11.vapi',
        meson.source_root() + '/vapi/user.vapi'
    ],
    dependencies: [
        dependency('gio-2.0'),
        dependency('gobject-2.0'),
        dependency('x11'),
        dependency('imlib2'),
        meson.get_compiler('c').find_library('m', required: false)
    ],
    link_args: ['-L/usr/local/lib', '-lXext', '-lXpm', '-lXft', '-lcrypt'],
    install: true
)

# Add post install script
meson.add_install_script('meson/post_install.py')
