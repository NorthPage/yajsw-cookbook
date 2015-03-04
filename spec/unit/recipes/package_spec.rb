require 'spec_helper'


describe 'yajsw::package' do

  platforms = {
      'centos' => ['6.6'],
      'ubuntu' => ['14.04']
  }

  platforms.each do |platform, versions|
    versions.each do |version|

      context "on #{platform.capitalize} #{version}" do
        let (:chef_run) do
          ChefSpec::SoloRunner.new(log_level: :error, platform: platform, version: version) do |node|
            # set additional node attributes here
          end.converge(described_recipe)
        end

        let(:install_script) { chef_run.remote_file('/usr/local/yajsw-stable-11.11.zip') }

        it "should download the yajsw archive and notify the installation" do
          expect(chef_run).to create_remote_file_if_missing('/usr/local/yajsw-stable-11.11.zip').with(owner: 'root')
          expect(install_script).to notify('libarchive_file[extract_yajsw]').to(:extract).immediately
        end
      end
    end
  end
end
