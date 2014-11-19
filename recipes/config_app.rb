#
# Cookbook Name:: yajsw-cookbook
# Recipe:: config_app
#
# Copyright (C) 2014 NorthPage
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

directory node['yajsw']['appsdir'] do
  recursive true
  owner 'root'
  group 'root'
  action :create
end

if node['yajsw']['use_data_bag']
  # TODO: set apps hash from data bag items
  apps = []
else
  apps = node['yajsw']['apps']
end

apps.each do |app|

  apphome = "#{node['yajsw']['appsdir']}/#{app['name']}"

  user app['user'] do
    action :create
  end

  %w{ conf deploy tmp log }.each do |d|
    directory "#{apphome}/#{d}" do
      recursive true
      owner app['user']
      action :create
    end
  end

  template "/etc/init.d/#{app['name']}" do
    source "yajsw_init_script.erb"
    variables({
      :appname => app['name'],
      :pidfile_dir => node['yajsw']['pidfile_dir'],
      :apphome => apphome,
      :yajswhome => "#{node['yajsw']['basedir']}/#{node['yajsw']['dirname']}"
    })
    owner 'root'
    group 'root'
    mode 0755
  end

  template "#{apphome}/conf/wrapper.conf" do
    source 'yajsw_wrapper_conf.erb'
    variables({
      :app => app,
      :logfile => app['logfile']
    })
    owner app['user']
    mode 0755
  end
end
