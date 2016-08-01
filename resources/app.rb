# resources/app.rb
#
# Cookbook Name:: yajsw
# Resource:: app
#
# Copyright (C) 2015-2016 NorthPage
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

property :name, String, name_property: true
property :apps_home, String, default: '/usr/local/yajsw_apps'
property :yajsw_home, String, default: '/usr/local/yajsw-stable-11.11'
property :pidfile_dir, String, default: '/var/run'
property :yajsw_user, String, default: 'root'
property :mainclass, String, required: true
property :jar, String
property :initmemory, Integer, default: 64
property :maxmemory, Integer, default: 256
property :classpath, Array, default: []
property :additional, Array, default: []
property :parameters, Array, default: []
property :logfile, Hash, default: { 'maxfiles' => 10,
                                    'maxsize' => '10m',
                                    'loglevel' => 'INFO' }
property :cookbook, String, default: 'yajsw'
property :java, String, default: "#{node['java']['java_home']}/bin/java"
property :manage_user, [TrueClass, FalseClass], default: false

default_action :create

action :create do
  app_directory = "#{apps_home}/#{name}"

  directory app_directory do
    recursive true
    owner 'root'
    group 'root'
    action :create
  end

  user yajsw_user do
    action :create
    only_if { manage_user }
  end

  %w( conf deploy tmp log ).each do |d|
    dir = "#{app_directory}/#{d}"
    directory dir do
      recursive true
      owner yajsw_user
      action :create
    end
  end

  case node['yajsw']['init_system']
  when 'systemd'
    execute 'reload-systemd-daemon' do
      command 'systemctl daemon-reload'
      action :nothing
    end

    template "/etc/systemd/system/#{name}.service" do
      source 'yajsw_init.systemd.erb'
      cookbook new_resource.cookbook
      owner 'root'
      group 'root'
      mode 0755
      variables(
        appname: new_resource.name,
        pidfile_dir: pidfile_dir,
        apphome: app_directory,
        yajswhome: yajsw_home,
        java: java
      )
      action :create
      notifies :run, 'execute[reload-systemd-daemon]', :immediately
    end
  when 'initd'
    template "/etc/init.d/#{name}" do
      source 'yajsw_init.sysv.erb'
      cookbook new_resource.cookbook
      owner 'root'
      group 'root'
      mode 0755
      variables(
        appname: new_resource.name,
        pidfile_dir: pidfile_dir,
        apphome: app_directory,
        yajswhome: yajsw_home,
        java: java
      )
      action :create
    end
  when 'upstart'
    template "/etc/init.d/#{name}.conf" do
      source 'yajsw_init.upstart.erb'
      cookbook new_resource.cookbook
      owner 'root'
      group 'root'
      mode 0755
      variables(
        appname: new_resource.name,
        pidfile_dir: pidfile_dir,
        apphome: app_directory,
        yajswhome: yajsw_home,
        java: java
      )
      action :create
    end
  else
    Chef::Log.error "Unsupported init system: '#{node['yajsw']['init_system']}'"
  end

  template "#{app_directory}/conf/wrapper.conf" do
    cookbook new_resource.cookbook
    source 'wrapper.conf.erb'
    owner yajsw_user
    mode 0755
    variables(
      appname: new_resource.name,
      appuser: yajsw_user,
      jar: jar,
      classpath: classpath,
      additional: additional,
      parameters: parameters,
      mainclass: mainclass,
      initmemory: initmemory,
      maxmemory: maxmemory,
      logfile: logfile
    )
  end
end

action :delete do
  case node['yajsw']['init_system']
  when 'systemd'
    file "/usr/lib/systemd/system/#{new_resource.name}.service" do
      action :delete
    end
  when 'initd'
    file "/etc/init.d/#{new_resource.name}" do
      action :delete
    end
  when 'upstart'
    file "/etc/init.d/#{new_resource.name}.conf" do
      action :delete
    end
  end

  directory "#{app_home}/#{new_resource.name}" do
    recursive true
    action :delete
  end

  user yajsw_user do
    action :remove
    only_if { manage_user }
  end
end
