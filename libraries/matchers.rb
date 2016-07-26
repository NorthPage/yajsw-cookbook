if defined?(ChefSpec)
  def create_yajsw_app(app)
    ChefSpec::Matchers::ResourceMatcher.new(:yajsw_app, :create, app)
  end

  def install_yajsw(install)
    ChefSpec::Matchers::ResourceMatcher.new(:yajsw_install, :create, install)
  end
end
