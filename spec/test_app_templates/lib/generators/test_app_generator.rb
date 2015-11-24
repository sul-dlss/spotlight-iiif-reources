require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../spec/test_app_templates", __FILE__)

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  def add_gems
    gem 'blacklight-spotlight'
    Bundler.with_clean_env do
      run 'bundle install --quiet'
    end
  end

  def run_blacklight_generator
    say_status('warning', 'GENERATING BL', :yellow)
    generate 'blacklight:install', '--devise --jettywrapper'
  end

  def run_spotlight_migrations
    rake 'spotlight:install:migrations'
    rake 'db:migrate'
  end

  def add_spotlight_routes_and_assets
    # spotlight will provide its own catalog controller.. remove blacklight's to
    # avoid getting prompted about file conflicts
    remove_file 'app/controllers/catalog_controller.rb'

    generate 'spotlight:install', '-f --mailer_default_url_host=localhost:3000'
  end

#  def install_engine
#    generate 'spotlight-iiif-resources:install'
#  end

end
