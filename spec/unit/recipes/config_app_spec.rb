require 'spec_helper'


describe 'yajsw::config_app' do

  platforms = {
      'centos' => ['6.5'],
      'ubuntu' => ['12.04', '14.04']
  }

  platforms.each do |platform, versions|
    versions.each do |version|

      context "on #{platform.capitalize} #{version}" do
        let (:chef_run) do
          ChefSpec::Runner.new(log_level: :warn, platform: platform, version: version) do |node|
            # set additional node attributes here
          end.converge(described_recipe)
        end

        it "should create the top level applications directory" do
          expect(chef_run).to create_directory('/usr/local/yajsw_apps')
        end

        it "should create the yajsw application user" do
          expect(chef_run).to create_user('yajsw')
        end

        it "should create application specific yajsw subdirs" do
          expect(chef_run).to create_directory('/usr/local/yajsw_apps/myapp/conf')
          expect(chef_run).to create_directory('/usr/local/yajsw_apps/myapp/deploy')
          expect(chef_run).to create_directory('/usr/local/yajsw_apps/myapp/tmp')
          expect(chef_run).to create_directory('/usr/local/yajsw_apps/myapp/log')
        end

        it "should render the init script for the default app" do
          expect(chef_run).to render_file('/etc/init.d/myapp').with_content(/^APP_HOME=\/usr\/local\/yajsw_apps\/myapp$/)
        end

        it "should render the yajsw wrapper config for the default app" do
          expect(chef_run).to render_file('/usr/local/yajsw_apps/myapp/conf/wrapper.conf').with_content(/wrapper\.java\.app\.jar=lib\/com\.company\.myapp\.jar$/)
        end
      end
    end
  end
end
