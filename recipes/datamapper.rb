gem_install 'datamapper'

add_require 'dm-core'
add_require 'dm-validations'

create_file 'config/datamapper.example.yml', I(%{
  defaults: &defaults
    :adapter: sqlite3
    :host: localhost
    :username: 
    :password: 

  :development:
    <<: *defaults
    :database: #{app_name}_development

  :test:
    <<: *defaults
    :database: #{app_name}_test

  :production:
    <<: *defaults
    :database: #{app_name}_production
})

create_file 'lib/thors/datamapper.thor', I(%{
  class Monk < Thor
    add_config_file 'config/datamapper.example.yml'
  end
})

add_initializer I(%{
  DataMapper.setup(:default, app_config(:datamapper))
})

add_class_def I(%{
  configure :development do
    DataMapper::Logger.new(STDOUT, :debug)
  end
})

append_file '.gitignore', I(%{
  /config/datamapper.yml
})
