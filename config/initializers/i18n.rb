require 'i18n'

I18n.load_path << Dir[File.expand_path("config/locales/**/*.{yml,yaml,rb}") ]
I18n.default_locale = :en
I18n.backend.load_translations
