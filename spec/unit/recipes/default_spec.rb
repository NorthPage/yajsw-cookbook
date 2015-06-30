require 'spec_helper'

describe 'yajsw::default' do

  platforms = {
    'centos' => ['6.6', '7.0'],
    'ubuntu' => ['14.04']
  }

  platforms.each do |platform, versions|
    versions.each do |version|

      context "on #{platform.capitalize} #{version}" do
        let (:chef_run) do
          ChefSpec::SoloRunner.new(log_level: :error, platform: platform, version: version) do |node|
          end.converge(described_recipe)
        end

        it 'should include yajsw::prep by default' do
          expect(chef_run).to include_recipe('yajsw::prep')
        end

        it 'should include yajsw::package by default' do
          expect(chef_run).to include_recipe('yajsw::package')
        end

        it 'should include yajsw::config_app by default' do
          expect(chef_run).to include_recipe('yajsw::config_app')
        end
      end
    end
  end
end
