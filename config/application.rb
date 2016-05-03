require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kakeibo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.autoload_paths += %W(#{config.root}/lib)
    config.time_zone = "Tokyo"
    config.i18n.default_locale = :ja
    config.encoding = "utf-8"
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
#    config.after_initialize do
#      $form_select用 = [ ["物理", 1], ["仮想", 2] ]# ここに処理を記述
#    end
# OK ,but move to /config/initializers/my_config/my_config01.rb
# OK    config.after_initialize do
# OK      $exkindx_sel_m = YAML.load(
# OK        File.read("#{Rails.root}/config/expkindx_inp.yml"))
# OK    end
  end
end
