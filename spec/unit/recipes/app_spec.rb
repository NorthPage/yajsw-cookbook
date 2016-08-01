require 'spec_helper'

describe 'yajsw::app' do
  platforms = {
    'centos' => ['6.8', '7.0'],
    'ubuntu' => ['14.04', '15.10']
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(step_into: ['yajsw_app'], log_level: :error,
                                   platform: platform, version: version) do
            # set additional node attributes here
          end.converge(described_recipe)
        end

        it 'should create the yajsw_app myapp' do
          expect(chef_run).to create_yajsw_app('myapp')
        end
      end
    end
  end
end
