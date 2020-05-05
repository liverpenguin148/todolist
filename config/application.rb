require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Todolist
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    
    # デフォルトのlocaleを日本語にする
    config.i18n.default_locale = :ja
    # i18nのロケールファイルが読み込まれるよう、pathを通す
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end
