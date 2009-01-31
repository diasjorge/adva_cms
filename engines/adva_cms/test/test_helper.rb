raise "about to load #{__FILE__} twice. make sure to require stuff with File.expand_path" if defined?(RAILS_GEM_VERSION)

ENV["RAILS_ENV"] = "test"
dir = File.dirname(__FILE__)
require File.expand_path(dir + "/../../../../../config/environment")

require 'matchy'
require 'test_help'
require 'with'
require 'with-sugar'

require 'webrat'
require 'webrat/rails'
Webrat.configuration.open_error_files = false

require 'globalize/i18n/missing_translations_raise_handler'
I18n.exception_handler = :missing_translations_raise_handler

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
  
  def setup_with_test_setup
    setup_without_test_setup
    start_db_transaction!
    setup_page_caching!
    setup_assets_dir!
    setup_themes_dir!

    I18n.locale = nil
    I18n.default_locale = :en
  end
  alias_method_chain :setup, :test_setup
  
  def teardown_with_test_setup
    teardown_without_test_setup
  ensure
    rollback_db_transaction!
    clear_cache_dir!
    clear_assets_dir!
    clear_themes_dir!
  end
  alias_method_chain :teardown, :test_setup
end

require_all dir + "/test_helper/**/database.rb",
            dir + "/test_helper/**/*.rb",
            dir + "/../../**/test/test_helper/database.rb",
            dir + "/../../**/test/test_helper/*.rb"

