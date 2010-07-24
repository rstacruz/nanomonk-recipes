gem_install "ohm"

add_require "ohm"

add_initializer %{
  # Connect to redis database.
  Ohm.connect(appconfig(:redis))
}

create_file 'config/redis/development.example.conf', I(%{
  # Redis configuration file example
  
  # By default Redis does not run as a daemon. Use 'yes' if you need it.
  # Note that Redis will write a pid file in /var/run/redis.pid when daemonized.
      daemonize yes
  
  # APPENDONLY IS THE PREFERRED WAY OF PERSISTING DATA
  # appendonly no 
      appendonly yes 
  
  # IF YOU HAVE TIGHT INTEGRITY REQUIREMENTS, USE ALWAYS
  # if soso (typical social network) use everysec
  # if you don't really if data is lost use no
  # appendfsync always
  # appendfsync no
      appendfsync everysec
  
  # When run as a daemon, Redis write a pid file in /var/run/redis.pid by default.
  # You can specify a custom pid file location here.
      pidfile ./redis.pid
  
  # Accept connections on the specified port, default is 6379
      port 6379
  
  # If you want you can bind a single interface, if the bind option is not
  # specified all the interfaces will listen for connections.
  #
  # bind 127.0.0.1
  
  # Close the connection after a client is idle for N seconds
      timeout 300
  
  # Save the DB on disk:
  #
  #   save <seconds> <changes>
  #
  #   Will save the DB if both the given number of seconds and the given
  #   number of write operations against the DB occurred.
  #
  #   In the example below the behaviour will be to save:
  #   after 900 sec (15 min) if at least 1 key changed
  #   after 300 sec (5 min) if at least 10 keys changed
  #   after 60 sec if at least 10000 keys changed
  #
  #   == DISABLE THIS SINCE WE'RE DOING APPENDONLY ==
  #   save 900 1
  #   save 300 10
  #   save 60 10000
  
  # For default save/load DB in/from the working directory
  # Note that you must specify a directory not a file name.
      dir ./db/redis/development
  
  # Set server verbosity to 'debug'
  # it can be one of:
  # debug (a lot of information, useful for development/testing)
  # notice (moderately verbose, what you want in production probably)
  # warning (only very important / critical messages are logged)
      loglevel debug
  
  # Specify the log file name. Also 'stdout' can be used to force
  # the demon to log on the standard output. Note that if you use standard
  # output for logging but daemonize, logs will be sent to /dev/null
      logfile stdout
  
  # Set the number of databases.
      databases 16
  
  ################################# REPLICATION #################################
  
  # Master-Slave replication. Use slaveof to make a Redis instance a copy of
  # another Redis server. Note that the configuration is local to the slave
  # so for example it is possible to configure the slave to save the DB with a
  # different interval, or to listen to another port, and so on.
  
  # slaveof <masterip> <masterport>
  
  ################################## SECURITY ###################################
  
  # Require clients to issue AUTH <PASSWORD> before processing any other
  # commands.  This might be useful in environments in which you do not trust
  # others with access to the host running redis-server.
  #
  # This should stay commented out for backward compatibility and because most
  # people do not need auth (e.g. they run their own servers).
  
  # requirepass foobared
  
  ################################ VIRTUAL MEMORY ###############################
  
  # Virtual Memory allows Redis to work with datasets bigger than the actual
  # amount of RAM needed to hold the whole dataset in memory.
  # In order to do so very used keys are taken in memory while the other keys
  # are swapped into a swap file, similarly to what operating systems do
  # with memory pages.
  #
  # To enable VM just set 'vm-enabled' to yes, and set the following three
  # VM parameters accordingly to your needs.
  
  # vm-enabled no
  # vm-enabled yes
  
  # This is the path of the Redis swap file. As you can guess, swap files
  # can't be shared by different Redis instances, so make sure to use a swap
  # file for every redis process you are running.
  #
  # The swap file name may contain "%p" that is substituted with the PID of
  # the Redis process, so the default name /tmp/redis-%p.vm will work even
  # with multiple instances as Redis will use, for example, redis-811.vm
  # for one instance and redis-593.vm for another one.
  #
  # Useless to say, the best kind of disk for a Redis swap file (that's accessed
  # at random) is a Solid State Disk (SSD).
  #
  # *** WARNING *** if you are using a shared hosting the default of putting
  # the swap file under /tmp is not secure. Create a dir with access granted
  # only to Redis user and configure Redis to create the swap file there.
  # vm-swap-file /tmp/redis-%p.vm
  
  # vm-max-memory configures the VM to use at max the specified amount of
  # RAM. Everything that deos not fit will be swapped on disk *if* possible, that
  # is, if there is still enough contiguous space in the swap file.
  #
  # With vm-max-memory 0 the system will swap everything it can. Not a good
  # default, just specify the max amount of RAM you can in bytes, but it's
  # better to leave some margin. For instance specify an amount of RAM
  # that's more or less between 60 and 80% of your free RAM.
  # vm-max-memory 0
  
  # Redis swap files is split into pages. An object can be saved using multiple
  # contiguous pages, but pages can't be shared between different objects.
  # So if your page is too big, small objects swapped out on disk will waste
  # a lot of space. If you page is too small, there is less space in the swap
  # file (assuming you configured the same number of total swap file pages).
  #
  # If you use a lot of small objects, use a page size of 64 or 32 bytes.
  # If you use a lot of big objects, use a bigger page size.
  # If unsure, use the default :)
  # vm-page-size 32
  
  # Number of total memory pages in the swap file.
  # Given that the page table (a bitmap of free/used pages) is taken in memory,
  # every 8 pages on disk will consume 1 byte of RAM.
  #
  # The total swap size is vm-page-size * vm-pages
  #
  # With the default of 32-bytes memory pages and 134217728 pages Redis will
  # use a 4 GB swap file, that will use 16 MB of RAM for the page table.
  #
  # It's better to use the smallest acceptable value for your application,
  # but the default is large in order to work in most conditions.
  # vm-pages 134217728
  
  # Max number of VM I/O threads running at the same time.
  # This threads are used to read/write data from/to swap file, since they
  # also encode and decode objects from disk to memory or the reverse, a bigger
  # number of threads can help with big objects even if they can't help with
  # I/O itself as the physical device may not be able to couple with many
  # reads/writes operations at the same time.
  #
  # The special value of 0 turn off threaded I/O and enables the blocking
  # Virtual Memory implementation.
  # vm-max-threads 4
  
  ############################### ADVANCED CONFIG ###############################
  
  # Glue small output buffers together in order to send small replies in a
  # single TCP packet. Uses a bit more CPU but most of the times it is a win
  # in terms of number of queries per second. Use 'yes' if unsure.
      glueoutputbuf yes
  
  # Hashes are encoded in a special way (much more memory efficient) when they
  # have at max a given numer of elements, and the biggest element does not
  # exceed a given threshold. You can configure this limits with the following
  # configuration directives.
      hash-max-zipmap-entries 64
      hash-max-zipmap-value 512
  
  # Active rehashing uses 1 millisecond every 100 milliseconds of CPU time in
  # order to help rehashing the main Redis hash table (the one mapping top-level
  # keys to values). The hash table implementation redis uses (see dict.c)
  # performs a lazy rehashing: the more operation you run into an hash table
  # that is rhashing, the more rehashing "steps" are performed, so if the
  # server is idle the rehashing is never complete and some more memory is used
  # by the hash table.
  # 
  # The default is to use this millisecond 10 times every second in order to
  # active rehashing the main dictionaries, freeing memory when possible.
  #
  # If unsure:
  # use "activerehashing no" if you have hard latency requirements and it is
  # not a good thing in your environment that Redis can reply form time to time
  # to queries with 2 milliseconds delay.
  #
  # use "activerehashing yes" if you don't have such hard requirements but
  # want to free memory asap when possible.
      activerehashing yes
  
  ################################## INCLUDES ###################################
  
  # Include one or more other config files here.  This is useful if you
  # have a standard template that goes to all redis server but also need
  # to customize a few per-server settings.  Include files can include
  # other files, so use this wisely.
  #
  # include /path/to/local.conf
  # include /path/to/other.conf
})

create_file 'config/redis/test.example.conf', I(%{
  # Redis configuration file example
  
  daemonize yes
  pidfile ./redis.pid
  port 6380
  # bind 127.0.0.1
  timeout 300
  save 900 1
  save 300 10
  save 60 10000
  dir ./db/redis/test
  loglevel debug
  logfile stdout
  databases 16
  glueoutputbuf yes
})

create_file 'lib/thors/redis.thor', I(%{
  class Monk < Thor
    desc "redis ENV", "Start the redis server in the supplied environment"
    def redis(env = ENV['RACK_ENV'] || 'development')
      verify_config(env)
      run "redis-server \\"\#{root_path}/config/redis/\#{env}.conf\\""
    end
  private
    alias verify_config_redis verify_config

    def verify_config(env)
      verify_config_redis env
      verify "\#{root_path}/config/redis/\#{env}.example.conf"
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

add_test_setup I(%{
  # Remove this if you don't want a fresh database everytime.
  Ohm.flush
})

notes "redis", I(%{
  Installing redis
  ----------------

  First: install Redis 2.0rc1, if you haven't yet:
  http://code.google.com/p/redis/

    curl http://redis.googlecode.com/files/redis-2.0.0-rc1.tar.gz | tar -zxvf -
    cd redis-2.0.0-rc1
    make
    sudo cp redis-{server,cli,benchmark,check-aof,check-dump} /usr/local/bin
    cd ..
    rm -rf redis-2.0.0-rc1

  Starting the redis server
  -------------------------

    monk redis
})

append_file '.gitignore', I(%{
  /config/redis/development.conf
  /config/redis/test.conf
  /db/redis/development
  /db/redis/test
})
