require "socket"


# Following: https://dev.twitch.tv/docs/chat/irc/
module TwitchIRC
  struct Client
    # @domain : String
    # @port : Int32
    def initialize(domain : String = "irc.chat.twitch.tv", port : Int32 = 6667)
      @client = TCPSocket.new(domain, port)
      # @client.tcp_nodelay = true
    end

    def listen
      spawn do
        loop do
          @client.each_line do |line|
            puts line
          end
        end
        sleep
      end
    end

    def send_raw(msg : String)
      @client << "#{msg}"
    end

    def send(msg : String)
      @client << "#{msg}\n"
      sleep 1000.milliseconds
    end

    def send_privmsg(msg : String, channel : String)
      @client << "PRIVMSG ##{channel} :#{msg}\n"
    end

    def join(channel : String | Array(String))
      @client << "JOIN ##{channel}\r\n"
      sleep 1000.milliseconds
    end

    def capabilities
      self.send("CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands")
    end

    def ping
      self.send("PING :tmi.twitch.tv")
    end

    def pong
      spawn do
        loop do
          puts @client.gets
        end
        sleep
      end
    end
  end
end
sleep
