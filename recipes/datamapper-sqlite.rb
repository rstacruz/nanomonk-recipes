gem_install 'datamapper'
gem_install 'sqlite3-ruby'
gem_install 'dm-sqlite-adapter'

add_require 'dm-core'
add_require 'dm-validations'
add_require 'dm-sqlite-adapter'

create_file 'config/datamapper.example.yml', I(%{
  defaults: &defaults
    :adapter: sqlite3
    :host: localhost
    :username: 
    :password: 

  :development:
    <<: *defaults
    :database: db/sqlite/development

  :test:
    <<: *defaults
    :database: db/sqlite/test

  :production:
    <<: *defaults
    :database: db/sqlite/production
})

empty_directory 'db/sqlite/test'
empty_directory 'db/sqlite/production'

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
  /db/sqlite
})
