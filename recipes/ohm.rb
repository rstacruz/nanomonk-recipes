gem_install "ohm"

add_require "ohm"

add_initializer %{
  # Connect to redis database.
  Ohm.connect(appconfig(:redis))
}

create_file 'config/redis/development.example.conf', I(%{
  ..
})

create_file 'config/redis/test.example.conf', I(%{
  ..
})

create_file 'lib/thors/redis.thor', I(%{
  class Monk < Thor
    desc "redis ENV", "Start the redis server in the supplied environment"
    def redis(env = ENV['RACK_ENV'] || 'development')
      verify_config env
      exec "redis-server \"#{root_path}/config/redis/#{env}.conf\""
    end
  end
})

empty_directory 'db/redis/development'
empty_directory 'db/redis/test'

add_config I(%{
  defaults: &defaults
    :log_level: warn
    :redis:
      :port: 6379

  :development:
    <<: *defaults
    :log_level: debug

  :test:
    <<: *defaults
    :redis:
      :port: 6380

  :production:
    <<: *defaults
})
