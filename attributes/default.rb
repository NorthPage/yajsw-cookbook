
# install java as a dependency?
default['yajsw']['install_java'] = true

# yajsw download location
# TODO figure out how to get permalinks from sourceforge
default['yajsw']['marker'] = 'stable'
default['yajsw']['version'] = '11.11'
default['yajsw']['checksum'] = 'aeb845a7d77184b8a1cbd68ae26c7f07a74952f6e79fb31d3f8f41ba52c4c872'
default['yajsw']['url'] = "http://heanet.dl.sourceforge.net/project/yajsw/yajsw/yajsw-#{node['yajsw']['marker']}-#{node['yajsw']['version']}/yajsw-#{node['yajsw']['marker']}-#{node['yajsw']['version']}.zip"
default['yajsw']['dirname'] = 'yajsw-stable-11.11'

# yajsw install location
default['yajsw']['basedir'] = '/usr/local'
default['yajsw']['apps_home'] = '/usr/local/yajsw_apps'
default['yajsw']['pidfile_dir'] = '/var/run'

# yajsw user
default['yajsw']['user'] = 'root'

# should yajsw use data bags to collect application config?
default['yajsw']['use_data_bag'] = false
default['yajsw']['data_bag_name'] = 'yajsw_apps'
default['yajsw']['use_env_data_bags'] = true

# array of yajsw managed applications
default['yajsw']['apps'] = [{ 'name' => 'myapp',
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

# init systems are :shit:
case node['platform_family']
when 'rhel'
  if node['platform_version'].to_i >= 7
    default['yajsw']['init_system'] = 'systemd'
  else
    default['yajsw']['init_system'] = 'initd'
  end
when 'debian'
  if node['platform'] == 'ubuntu' && node['platform_version'].to_i >= 15
    default['yajsw']['init_system'] = 'systemd'
  elsif node['platform'] == 'ubuntu'
    default['yajsw']['init_system'] = 'upstart'
  elsif node['platform'] == 'debian' && node['platform_version'].to_i >= 8
    default['yajsw']['init_system'] = 'systemd'
  else
    default['yajsw']['init_system'] = 'initd'
  end
else
  default['yajsw']['init_system'] = 'initd'
end
