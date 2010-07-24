gem_install "sinatra-minify"
add_require "sinatra/minify"

create_file 'lib/tasks/minify.rake', I(%{
  desc "Builds the minified CSS and JS assets."
  task :minify do
    require './init'
    files = Sinatra::Minify::Package.build
    files.each { |f| puts " * \#{File.basename f}" }
  end
})

create_file 'config/assets.yml', I(%{
  css:
    base:
      - main.css

  js:
    base:
      #- jquery-1.4.2.min.js
      #- app.js
})

add_class_def I(%{
  register Sinatra::Minify
})

if File.exists?('app/views/layout.haml')
  inject_into_file 'app/views/layout.haml', '    != css_assets :base', :before => '%body'
  append_file      'app/views/layout.haml', '    != js_assets :base'
else
  caveats I(%{
    Adding assets:

      A templating gem wasn't found in your project.
      You will need to add the following to your templates:

        <%= css_assets :base %>    (right before </head>)
        <%= js_assets :base %>     (right before </body>)

      Refer to the sinatra-minify documentation for more info.
  })
end

notes "minify", I(%{
  Minifying files
  ---------------

  To generate the minified files, do:

      rake minify

  This will put the packaged minified CSS/JS files into the public/ directory.
})
