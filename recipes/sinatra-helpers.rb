gem_install "sinatra-helpers"
add_require "sinatra/helpers"

add_class_def I(%{
  register Sinatra::Helpers
})
