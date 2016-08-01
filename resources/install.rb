# resources/install.rb
#
# Cookbook Name:: yajsw
# Resource:: install
#
# Copyright 2015-2016 NorthPage
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

property :name, String, name_property: true, default: 'default'
property :url, String, default: nil
property :marker, String, default: 'stable'
property :version, String, default: '11.11'
property :basedir, String, default: '/usr/local'
property :checksum, String, default: ''
property :user, String, default: 'root'

default_action :create

action :create do
  if new_resource.url.nil?
    new_resource.url = "http://heanet.dl.sourceforge.net/project/yajsw/yajsw/yajsw-#{marker}-#{version}/yajsw-#{marker}-#{version}.zip"
  end

  file = "yajsw-#{marker}-#{version}.zip"
  archive_path = "#{basedir}/#{file}"

  include_recipe 'libarchive::default'

  libarchive_file 'extract_yajsw' do
    path archive_path
    extract_to basedir
    owner new_resource.user
    action :nothing
  end

  remote_file archive_path do
    source new_resource.url
    owner new_resource.user
    checksum new_resource.checksum
    action :create_if_missing
    notifies :extract, 'libarchive_file[extract_yajsw]', :immediately
  end
end

action :delete do
  file = "yajsw-#{marker}-#{version}.zip"
  archive_path = "#{basedir}/#{file}"
  yajsw_home = "#{basedir}/yajsw-#{marker}-#{version}"

  file archive_path do
    action :delete
  end

  directory yajsw_home do
    recursive true
    action :delete
  end
end
