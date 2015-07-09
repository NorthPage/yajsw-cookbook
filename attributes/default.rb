
# yajsw download location
# TODO figure out how to get permalinks from sourceforge
default['yajsw']['url'] = 'http://iweb.dl.sourceforge.net/project/yajsw/yajsw/yajsw-stable-11.11/yajsw-stable-11.11.zip'
default['yajsw']['file'] = 'yajsw-stable-11.11.zip'
default['yajsw']['checksum'] = 'aeb845a7d77184b8a1cbd68ae26c7f07a74952f6e79fb31d3f8f41ba52c4c872'
default['yajsw']['dirname'] = 'yajsw-stable-11.11'

# yajsw install location
default['yajsw']['basedir'] = '/usr/local'
default['yajsw']['appsdir'] = '/usr/local/yajsw_apps'
default['yajsw']['pidfile_dir'] = '/var/run'

# yajsw user
default['yajsw']['user'] = 'root'

# should yajsw use data bags to collect application config?
default['yajsw']['use_data_bag'] = false
default['yajsw']['data_bag_name'] = 'yajsw_apps'
default['yajsw']['use_env_data_bags'] = true

# array of yajsw managed applications
default['yajsw']['apps'] = [{
                              'name' => 'myapp',
                              'user' => 'yajsw',
                              'initmemory' => 64,
                              'maxmemory' => 256,
                              'mainclass' => 'com.company.myapp',
                              'jar' => 'lib/com.company.myapp.jar',
                              'classpath' => [],
                              'additional' => ['-server', '-Dfile.encoding=UTF-8'],
                              'parameters' => [],
                              'logfile' => {
                                'maxfiles' => 10,
                                'maxsize' => '10m',
                                'loglevel' => 'INFO'
                              }
                            }]

# determine if we use systemd or initd
if node['platform_family'] == 'rhel' && Gem::Version.new(node['platform_version']) >= Gem::Version.new('7.0.0')
  default['yajsw']['init_system'] = 'systemd'
else
  default['yajsw']['init_system'] = 'initd'
end
