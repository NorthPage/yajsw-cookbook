#
# Cookbook Name:: yajsw-cookbook
# Recipe:: app
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

if node['yajsw']['use_data_bag']
  # TODO: set apps hash from data bag items
  apps = []
else
  apps = node['yajsw']['apps']
end

apps.each do |app|
  yajsw_app app['name'] do
    apps_home  node['yajsw']['apps_home']
    yajsw_user app['user']
    mainclass app['mainclass']
    jar app['jar']
    initmemory app['initmemory']
    maxmemory app['maxmemory']
    classpath app['classpath']
    additional app['java_additional']
    parameters app['parameters']
    logfile app['logfile']
    manage_user true
    java "#{node['java']['java_home']}/bin/java"
    action :create
  end

  service "yajsw_#{app['name']}" do
    service_name app['name']
    action [:enable, :start]
    only_if { ::File.exists? app['jar'] }
  end
end
