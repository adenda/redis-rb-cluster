#!/usr/bin/env ruby

require './cluster'
require 'logger'
require 'securerandom'

log = Logger.new(STDOUT)

log.info("Redis example client started")

# To create new keys:
#   ruby ./example.rb <seed_uri> <seed_port>
# To delete keys:
#   ruby ./example.rb <seed_uri> <seed_port> delete

startup_nodes = [
    {:host => ARGV[0], :port => ARGV[1].to_i}
]

delete = ARGV[2]

log.info("startup_nodes: #{startup_nodes}")

rc = RedisCluster.new(startup_nodes,32,:timeout => 0.1)

last = false
first = false
max_entries = 1000000000

while not last
    begin
        last = rc.get("__last__")
        last = 0 if !last
    rescue => e
        log.error("error #{e.to_s}")
        sleep 1
    end
end

while not first
    begin
        first = rc.get("__first__")
        first = 0 if !first
    rescue => e
        log.error("error #{e.to_s}")
        sleep 1
    end
end

if not delete
    (last.to_i+1).upto(max_entries).each { |x|
        begin
            key = SecureRandom.hex
            rc.set("foo#{x}", key)
            log.info("foo#{x}: " + rc.get("foo#{x}"))
            rc.set("__last__",x)
        rescue => e
            log.error("error #{e.to_s}")
        end
    }
elsif delete == "delete"
    (first.to_i).upto(last.to_i).each { |x|
        begin
            key = "foo#{x}"
            rc.del(key)
            log.info("#{key} deleted")
            rc.set("__first__", x)
        rescue => e
            log.error("error #{e.to_s}")
        end
    }
else
    print("Usage:")
    # To create new keys:
    #   ruby ./example.rb <seed_uri> <seed_port>
    # To delete keys:
    #   ruby ./example.rb <seed_uri> <seed_port> delete
    print("Create new keys:\n")
    print("  ruby ./example.rb <seed_uri> <seed_port>\n")
    print("Delete keys:\n")
    print("  ruby ./example.rb <seed_uri> <seed_port> delete")
end
