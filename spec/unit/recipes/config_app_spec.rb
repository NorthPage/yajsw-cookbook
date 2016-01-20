require 'spec_helper'

describe 'yajsw::config_app' do
  platforms = {
    'centos' => ['6.6', '7.0'],
    'ubuntu' => ['14.04']
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

        it 'should create the top level applications directory' do
          expect(chef_run).to create_directory('/usr/local/yajsw_apps')
        end

        it 'should create the yajsw application user' do
          expect(chef_run).to create_user('yajsw')
        end

        it 'should create application specific yajsw subdirs' do
          expect(chef_run).to create_directory('/usr/local/yajsw_apps/myapp/conf')
          expect(chef_run).to create_directory('/usr/local/yajsw_apps/myapp/deploy')
          expect(chef_run).to create_directory('/usr/local/yajsw_apps/myapp/tmp')
          expect(chef_run).to create_directory('/usr/local/yajsw_apps/myapp/log')
        end

        it 'should render the init script for the default app' do
          if platform == 'centos' && version.to_i >= 7
            expect(chef_run).to render_file('/usr/lib/systemd/system/myapp.service'
                                ).with_content(%r{^PIDFile=/var/run/wrapper.myapp.pid$})
          else
            expect(chef_run).to render_file('/etc/init.d/myapp'
                                ).with_content(%r{^APP_HOME=/usr/local/yajsw_apps/myapp$})
          end
        end

        it 'should render the yajsw wrapper config for the default app' do
          expect(chef_run).to render_file('/usr/local/yajsw_apps/myapp/conf/wrapper.conf'
                              ).with_content(%r{wrapper.java.app.jar=lib/com.company.myapp.jar$})
        end

        it 'should create yajsw app myapp' do
          expect(chef_run).to create_yajsw_app('myapp')
        end

        it 'should update yajsw app myapp' do
          expect(chef_run).to update_yajsw_app('myapp')
        end

        it 'should enable the myapp service' do
          expect(chef_run).to enable_service('myapp')
        end
      end
    end
  end
end
