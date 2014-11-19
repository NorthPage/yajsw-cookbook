#
# Cookbook Name:: yajsw-cookbook
# Recipe:: package
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

include_recipe "libarchive::default"

libarchive_file "extract_yajsw" do
  path "#{node['yajsw']['basedir']}/#{node['yajsw']['file']}"
  extract_to node['yajsw']['basedir']
  owner node['yajsw']['user']
  action :nothing
end

remote_file "#{node['yajsw']['basedir']}/#{node['yajsw']['file']}" do
  source node['yajsw']['url']
  owner node['yajsw']['user']
  checksum node['yajsw']['checksum']
  action :create_if_missing
  notifies :extract, "libarchive_file[extract_yajsw]", :immediately
end
