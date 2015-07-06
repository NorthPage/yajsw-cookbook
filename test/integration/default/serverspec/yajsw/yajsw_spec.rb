require 'spec_helper'

describe file('/usr/local/yajsw-stable-11.11') do
  it { should be_directory }
  it { should be_owned_by 'root' }
end

describe file('/usr/local/yajsw_apps') do
  it { should be_directory }
  it { should be_owned_by 'root' }
end

%w{ conf tmp deploy log }.each do |d|
  describe file("/usr/local/yajsw_apps/myapp/#{d}") do
    it { should be_directory }
    it { should be_owned_by 'yajsw' }
  end
end

if os[:family] == 'redhat' && Gem::Version.new(os[:release]) >= Gem::Version.new('7.0.0')
  describe file('/usr/lib/systemd/system/myapp.service') do
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content) { should match /^PIDFile=\/var\/run\/wrapper\.myapp\.pid/ }
  end
else
  describe file('/etc/init.d/myapp') do
    it { should be_file }
    it { should be_owned_by 'root' }
    its(:content) { should match /^APP_HOME=\/usr\/local\/yajsw_apps\/myapp/ }
  end
end

describe file('/usr/local/yajsw_apps/myapp/conf/wrapper.conf') do
  it { should be_file }
  it { should be_owned_by 'yajsw' }
  its(:content) { should match /wrapper\.java\.app\.jar=lib\/com\.company\.myapp\.jar/ }
end
