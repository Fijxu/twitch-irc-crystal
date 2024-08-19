require "socket"

module TwitchIRC
  struct Client
    @ip_addr : String
    @port : Int32
    @client : TCPSocket
    def initialize(@ip_addr, @port)
      @client = TCPSocket.new(@ip_addr, @port)
    end

    def listen
      spawn do
        loop do
          puts @client.gets
        end
      end
      sleep
    end

    def send_raw(msg : String)
      @client << "#{msg}"
    end

    def send(msg : String)
      @client << "#{msg}\n"
    end

    def send_privmsg(msg : String, channel : String)
      @client << "PRIVMSG ##{channel} :#{msg}\n"
    end

    def capabilities
      self.send("CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands")
    end
  end
end
