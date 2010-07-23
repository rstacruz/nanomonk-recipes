gem_install "spawn"
add_test_require "spawn"
add_test_require "./factories"

create_file "test/factories.rb", I(%{
  # [ User, Item, Photo ].each { |c| c.extend(Spawn) }
  #
  # User.spawner do |u|
  #   u.email      = Random.email
  #   u.first_name = Random.first_name
  #   u.last_name  = Random.last_name 
  # end
})
