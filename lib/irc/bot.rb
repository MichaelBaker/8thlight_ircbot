require 'cgi'
require_relative 'api/google_image'
require_relative 'api/wunderground'

module IRC
  class Bot
    def initialize(client)
      @client = client
    end

    def show_me(terms)
      messages = IRC::API::GoogleImage.query(terms)
      if messages.empty?
        @client.message("Image not found.")
      else
        @client.message(messages.sample)
      end
    end

    def weather_for(terms)
      messages = IRC::API::Wunderground.query(terms)
      if messages.empty?
        @client.message("City not found.")
      else
        messages.each do |message|
          @client.message(message)
        end
      end
    end

    def respond(input)
      puts "> #{input}"

      case input.strip
      when /^.*PING :(.+)$/i
        @client.pong($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: show me (.*)$/i
        show_me($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: weather for (.*)$/i
        weather_for($1)
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: reboot$/i
        raise Exception
      when /^.*PRIVMSG ##{@client.channel} :#{@client.nick}: what is the meaning of life(\?)?$/i
        @client.message("42.")
      end
    end
  end
end
