url = 'http://code.jquery.com/jquery-latest.js'

empty_directory 'public/js'
say_status :fetching, url
get url, 'public/js/jquery.js'
