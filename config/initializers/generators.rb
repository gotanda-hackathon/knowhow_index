Rails.application.config.generators do |g|
  g.stylesheets false
  g.javascripts false
  g.jbuilder false
  g.coffee false
  g.helper false
  g.skip_routes true
  g.test_framework :rspec,
                   view_specs: false,
                   helper_specs: false,
                   routing_specs: false,
                   request_specs: false,
                   controller_specs: false
end
