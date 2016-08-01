require 'spec_helper'

describe file('/usr/local/yajsw-stable-11.11') do
  it { should be_directory }
  it { should be_owned_by 'root' }
end

describe file('/usr/local/yajsw_apps') do
  it { should be_directory }
  it { should be_owned_by 'root' }
end

%w( conf tmp deploy log ).each do |d|
  describe file("/usr/local/yajsw_apps/myapp/#{d}") do
    it { should be_directory }
    it { should be_owned_by 'yajsw' }
  end
end

if (os[:family] == 'redhat' && os[:release].to_i >= 7) ||
    (os[:family] == 'ubuntu' && os[:release].to_i >= 15) ||
    (os[:family] == 'debian' && os[:release].to_i >= 8)
  describe file('/etc/systemd/system/myapp.service') do
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content) { should match(%r{^PIDFile=/var/run/wrapper.myapp.pid}) }
  end
elsif os[:family] == 'redhat' || os[:family] == 'debian'
  describe file('/etc/init.d/myapp') do
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content) { should match(%r{^APP_HOME=/usr/local/yajsw_apps/myapp}) }
  end
elsif os[:family] == 'ubuntu'
  describe file('/etc/init.d/myapp.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
  end
end

describe file('/usr/local/yajsw_apps/myapp/conf/wrapper.conf') do
  it { should be_file }
  it { should be_owned_by 'yajsw' }
  its(:content) { should match(%r{wrapper.java.app.jar=lib/com.company.myapp.jar}) }
end
