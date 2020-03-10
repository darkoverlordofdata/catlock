
install_data(
    join_paths(meson.project_name() + '.png'),
    install_dir: join_paths(get_option('datadir'), 'icons')
)

install_data(
    meson.project_name() + '.gschema.xml',
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas')
)

#
# this is so the desktop file points to the correct icon location,
# it will be either '/usr/local/share' or '/usr/share'
#
desktop_data = configuration_data()
desktop_data.set('prefix', join_paths(get_option('prefix'), 'share'))
configure_file(
              input: meson.project_name() + '.desktop.in',
              output: meson.project_name() + '.desktop',
              configuration : desktop_data,
              type: 'desktop',
              install: true,
              install_dir: join_paths(get_option('datadir'), 'applications')
 )

i18n = import('i18n')

# i18n.merge_file(
#   input: meson.project_name() + '.desktop.in',
#   output: meson.project_name() + '.desktop',
#   po_dir: join_paths(meson.source_root(), 'po'),
#   type: 'desktop',
#   install: true,
#   install_dir: join_paths(get_option('datadir'), 'applications')
# )

i18n.merge_file(
  input: meson.project_name() + '.appdata.xml.in',
  output: meson.project_name() + '.appdata.xml',
  po_dir: join_paths(meson.source_root(), 'po'),
  install: true,
  install_dir: join_paths(get_option('datadir'), 'metainfo')
)

desktop_file_validate = find_program('desktop-file-validate', required:false)

if desktop_file_validate.found()
  test (
    'Validate desktop file',
    desktop_file_validate,
    args: join_paths(meson.current_build_dir (), meson.project_name() + '.desktop')
  )
endif

appstreamcli = find_program(['appstreamcli', 'appstream-util'], required:false)

if appstreamcli.found()
  test (
    'Validate appdata file',
    appstreamcli,
    args: ['validate', join_paths(meson.current_build_dir (), meson.project_name() + '.appdata.xml')]
  )
endif
