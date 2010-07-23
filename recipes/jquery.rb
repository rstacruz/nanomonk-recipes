require 'open-uri'

contents = open('http://code.jquery.com/jquery-latest.js') { |f| f.read }

empty_directory 'public/js'

create_file 'public/js/jquery.js', contents
