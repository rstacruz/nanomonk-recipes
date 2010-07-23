gem_install "sinatra-i18n"
gem_install "i18n"
add_require "sinatra/i18n"

add_class_def I(%{
  register Sinatra::I18n
})
