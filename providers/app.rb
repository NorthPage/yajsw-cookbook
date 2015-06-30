#
# Cookbook Name:: yajsw-cookbook
# Provider:: yajsw_app.rb
#
# Copyright (C) 2015 NorthPage
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

def whyrun_supported?
  true
end

use_inline_resources

action :create do
  appname = new_resource.name
  appsdir = new_resource.appsdir
  apphome = "#{appsdir}/#{appname}"

  prep_apps_dir
  create_user
  create_app_dirs
  populate_init unless ::File.exist?("/etc/init.d/#{appname}")
  populate_wrapper unless ::File.exist?("#{apphome}/conf/wrapper.conf")
end

action :delete do
  # TODO
end

action :update do
  populate_init
  populate_wrapper
end

private

def prep_apps_dir
  appsdir = new_resource.appsdir

  unless ::File.directory?(appsdir)
    Chef::Log.info "Creating yajsw apps dir: #{appsdir}"
    a = directory appsdir do
      recursive true
      owner 'root'
      group 'root'
      action :create
    end
    new_resource.updated_by_last_action(a.updated_by_last_action?)
  end
end

def create_user
  appuser = new_resource.user

  if new_resource.create_user
    Chef::Log.info "Creating yajsw app user: #{appuser}"
    user appuser do
      action :create
    end
  end
end

def create_app_dirs
  appname = new_resource.name
  appsdir = new_resource.appsdir
  apphome = "#{appsdir}/#{appname}"
  appuser = new_resource.user

  %w{ conf deploy tmp log }.each do |d|
    dir = "#{apphome}/#{d}"
    unless ::File.directory?(dir)
      Chef::Log.info "Creating yajsw directory: #{dir}"
      a = directory dir do
        recursive true
        owner appuser
        action :create
      end
      new_resource.updated_by_last_action(a.updated_by_last_action?)
    end
  end
end

def populate_init
  appname = new_resource.name
  appsdir = new_resource.appsdir
  apphome = "#{appsdir}/#{appname}"
  piddir = new_resource.pidfile_dir
  home = new_resource.home
  java = new_resource.java

  t = template "/etc/init.d/#{appname}" do
    source 'yajsw_init.sysv.erb'
    cookbook new_resource.cookbook
    variables({
      :appname => appname,
      :pidfile_dir => piddir,
      :apphome => apphome,
      :yajswhome => home,
      :java => java
    })
    owner 'root'
    group 'root'
    mode 0755
    action :create
    only_if   { node['yajsw']['init_system'] == 'initd' }
  end

  t = template "/usr/lib/systemd/system/#{appname}.service" do
    source 'yajsw_init.systemd.erb'
    cookbook new_resource.cookbook
    variables({
      :appname => appname,
      :pidfile_dir => piddir,
      :apphome => apphome,
      :yajswhome => home,
      :java => java
    })
    owner 'root'
    group 'root'
    mode 0755
    action :create
    only_if   { node['yajsw']['init_system'] == 'systemd' }
  end

  new_resource.updated_by_last_action(t.updated_by_last_action?)
end

def populate_wrapper
  appname = new_resource.name
  appsdir = new_resource.appsdir
  apphome = "#{appsdir}/#{appname}"
  appuser = new_resource.user

  t = template "#{apphome}/conf/wrapper.conf" do
    cookbook new_resource.cookbook
    source 'wrapper.conf.erb'
    variables({
      :appname => appname,
      :appuser => appuser,
      :jar => new_resource.jar,
      :classpath => new_resource.classpath,
      :additional => new_resource.additional,
      :parameters => new_resource.parameters,
      :mainclass => new_resource.mainclass,
      :initmemory => new_resource.initmemory,
      :maxmemory => new_resource.maxmemory,
      :logfile => new_resource.logfile
    })
    owner appuser
    mode 0755
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end
