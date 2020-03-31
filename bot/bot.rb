require 'socket'
require 'open-uri'
require 'rubygems'
gem 'google-api-client', '>0.7'
require 'google/apis'
require 'google/apis/youtube_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

#require 'selenium-webdriver'
require 'fileutils'
require 'json'
require 'date'

TWITCH_HOST = "irc.chat.twitch.tv"
TWITCH_PORT = 6667
#Selenium::WebDriver::Chrome::Service #driver_path=F:/Jeff/Documents/Projects/Ruby/TwitchBot/bot/chromedriver_win32/chromedriver_win32.exe
class TwitchBot

  def initialize
    @nickname = "jeffbot"
    @password = File.read("F:/Jeff/Documents/Projects/Ruby/TwitchBotKeys/OauthToken.txt")
    @channel = "jeffboi"
    @socket = TCPSocket.open(TWITCH_HOST, TWITCH_PORT)

    write_to_system "PASS #{@password}"
    write_to_system "NICK #{@nickname}"
    write_to_system "USER #{@nickname} 0 * #{@nickname}"
    write_to_system "JOIN ##{@channel}"

  end

  def write_to_system(message)
    @socket.puts message
  end

  def write_to_chat(message)
    write_to_system "PRIVMSG ##{@channel} :#{message}"
    sleep(2)
  end

  def run
    playlist= Array[] #array for playlist currently inactive
    line= ''
    oldLine=''
    until @socket.eof? do
      message = @socket.gets
      puts message

      if message.match(/^PING :(.*)$/)
        write_to_system "PONG #{$~[1]}"
        line= File.readlines("testing.txt").sample
        if oldLine !=line
        write_to_chat(line)
        oldLine=line
        end
      end

      if message.match(/PRIVMSG ##{@channel} :(.*)$/)
        content = $~[1]
        username = message.match(/@(.*).tmi.twitch.tv/)[1]

         if content.include? "coffee"
           write_to_chat("PUT THAT COFFEE DOWN!!")
         end
        if content.include? "!hello"
          write_to_chat("Hello, "+username+"!")
        end
        if content.include? "!followage"
          response = open('http://decapi.me/twitch/followage/jeffboi/'+username).read
          write_to_chat(username+" has been following for "+response + ", Thanks!" )
        end
        if content.include? "anime"
          write_to_chat(username+ " loves anime!")
        end
      #  if content.include? "!playlist"
      #        write_to_chat("Starting playlist")
      #        startPlaylist(playlist)
      #    end
        if content.include? "!commands"
              write_to_chat("Here are some commands: !hello !followage  ")

          end
      #  if content.include? "!requestsong"
      #    s=content
      #    i =0
      #    j=0
      #    count=0
      #    while i<13
      #      s[j]=' '
      #      p s
      #      i+=1
      #      j+=1
      #    end
      #    s.lstrip!
      #    s.chop
      #    p s
      #    if s.include? "youtube.com"
#
#          write_to_chat("Your song was added!")
#          end

#        end
      end
    end
  end


  def quit
    write_to_chat "JeffBot is out"
    write_to_system "PART ##{@channel}"
    write_to_system "QUIT"
  end
end
#def startPlaylist(playlist)
  #driver = Selenium::WebDriver.for:chrome

  #  driver.get(playlist[0])
  #  element = driver.find_element :class => "ytp-time-duration"
  #  s = element.text
  #  p s
#  if dt = DateTime.parse(s) rescue false
#    t = dt.hour*60 + dt.min
#  end
#    p t
#    sleep t
#    driver.quit
#    playlist.delete_at(0)
 #end
bot = TwitchBot.new
trap("INT") { bot.quit }
bot.run
