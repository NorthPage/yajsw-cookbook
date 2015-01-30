if defined?(ChefSpec)
  def create_yajsw_app(app)
    ChefSpec::Matchers::ResourceMatcher.new(:yajsw_app, :create, app)
  end

  def update_yajsw_app(app)
    ChefSpec::Matchers::ResourceMatcher.new(:yajsw_app, :update, app)
  end
end
