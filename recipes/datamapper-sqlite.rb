gem_install 'datamapper'
gem_install 'sqlite3-ruby'

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
  private
    alias verify_config_datamapper verify_config
    def verify_config(env)
      verify_config_datamapper env
      verify "#\{root_path\}/config/datamapper.example.conf"
    end
  end
})

add_initializer I(%{
  DataMapper.setup(:default, config(:datamapper))
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
