require 'spec_helper'

describe 'yajsw::java' do
  platforms = {
    'centos' => ['6.8', '7.0'],
    'ubuntu' => ['14.04', '15.10']
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(log_level: :error, platform: platform, version: version) do
            # set additional node attributes here
          end.converge(described_recipe)
        end

        it 'should include java::default by default' do
          expect(chef_run).to include_recipe('java::default')
        end
      end
    end
  end
end
