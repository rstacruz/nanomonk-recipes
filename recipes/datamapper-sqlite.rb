install_package 'datamapper'

gem_install 'sqlite3-ruby'
gem_install 'dm-sqlite-adapter'
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
}), :force => true

empty_directory 'db/sqlite/test'
empty_directory 'db/sqlite/production'

append_file '.gitignore', I(%{
})
