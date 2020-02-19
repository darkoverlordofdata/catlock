
install_data(
    join_paths(meson.project_name() + '.png'),
    install_dir: join_paths(get_option('datadir'), 'icons')
)

install_data(
    join_paths(meson.project_name() + '.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons')
)


i18n = import('i18n')

i18n.merge_file(
  input: meson.project_name() + '.desktop.in',
  output: meson.project_name() + '.desktop',
  po_dir: join_paths(meson.source_root(), 'po'),
  type: 'desktop',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'applications')
)

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