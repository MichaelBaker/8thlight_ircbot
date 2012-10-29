require 'json'
require_relative 'bot'

module IRC
  class Connection
    def self.start(client, stdin = $stdin)
      bot = IRC::Bot.new(client)

      cant stop wont stop do
        ready = select([client.socket, stdin])
        next unless ready

        ready.first.each do |io|
          if io == client.socket
            input = client.socket.gets
            return unless input
            bot.respond(input)
          else
            input = io.gets
            client.message(input)
          end
        end
      end
    end

    def self.cant(*args, &block)
      while true
        block.call
      end
    end

    def self.stop(*args)
    end

    def self.wont(*args)
    end
  end
end
