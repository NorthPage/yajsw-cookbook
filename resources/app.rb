#
# Cookbook Name:: yajsw-cookbook
# Resource:: yajsw_app
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
actions :create, :delete, :update
default_action :create

attribute :name,        :kind_of => String, :name_attribute => true
attribute :appsdir,     :kind_of => String, :default => '/usr/local/yajsw_apps'
attribute :home,        :kind_of => String, :default => '/usr/local/yajsw-stable-11.11'
attribute :pidfile_dir, :kind_of => String, :default => '/var/run'
attribute :user,        :kind_of => String, :default => 'root'
attribute :mainclass,   :kind_of => String, :required => true
attribute :jar,         :kind_of => String, :required => true
attribute :initmemory,  :kind_of => Integer, :default => 64
attribute :maxmemory,   :kind_of => Integer, :default => 256
attribute :logfile,     :kind_of => Hash, :default => { 'maxfiles' => 10,
                                                        'maxsize' => '10m',
                                                        'loglevel' => 'INFO' }
attribute :cookbook,    :kind_of => String, :default => 'yajsw'
attribute :create_user, :kind_of => [TrueClass, FalseClass], :default => false
attribute :delete_user, :kind_of => [TrueClass, FalseClass], :default => false
