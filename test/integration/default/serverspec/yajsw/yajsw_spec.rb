require 'spec_helper'

describe file('/usr/local/yajsw-stable-11.11') do
  it { should be_directory }
end

describe file('/usr/local/yajsw_apps') do
  it { should be_directory }
end

%w{ conf tmp deploy log }.each do |d|
  describe file("/usr/local/yajsw_apps/myapp/#{d}") do
    it { should be_directory }
    it { should be_owned_by 'yajsw' }
  end
end

describe file('/etc/init.d/myapp') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should contain('APP_HOME=/usr/local/yajsw_apps/myapp') }
end

describe file('/usr/local/yajsw_apps/myapp/conf/wrapper.conf') do
  it { should be_file }
  it { should be_owned_by 'yajsw' }
  it { should contain('wrapper.java.app.jar=lib/com.company.myapp.jar') }
end
