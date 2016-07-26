require 'spec_helper'

describe 'yajsw::default' do
  platforms = {
    'centos' => ['6.6', '7.0'],
    'ubuntu' => ['14.04']
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(log_level: :error, platform: platform, version: version) do
          end.converge(described_recipe)
        end

        it 'should include yajsw::java by default' do
          expect(chef_run).to include_recipe('yajsw::java')
        end

        it 'should include yajsw::install by default' do
          expect(chef_run).to include_recipe('yajsw::install')
        end

        it 'should include yajsw::app by default' do
          expect(chef_run).to include_recipe('yajsw::app')
        end
      end
    end
  end
end
