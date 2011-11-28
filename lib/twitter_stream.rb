require 'em-http'

class TwitterStream

  def initialize(username, password, query={})
    @username, @password = username, password
    @query = query
    @buffer = ""
    @reconnections = 0
    @last_reconnection
    connect
  end

  def on_error(&block)
    @error_callback = block
  end

  def on_tweet(&block)
    @tweet_callback = block
  end

  private

  def connect
    http = EventMachine::HttpRequest.new('https://stream.twitter.com/1/statuses/filter.json').post({
      :head => { 'Authorization' => [@username,@password] },
      :query => @query
    })

    http.callback do
      unless http.response_header.status == 200
        puts "Call failed with response code #{http.response_header.status}"

        @reconnections = 0 if Time.now - @last_reconnection > 120 # Long enough to reset all reconnections

        if @reconnections < 5
          sleep(@reconnections * 48) # TODO Make exponential per API documentation
          connect
          @reconnections += 1
          @last_reconnection = Time.now
        else
          puts "Too many reconnections."
          report_error
        end
      end
    end

    http.errback do
      report_error
    end

    http.stream do |tweets|

      # Ignore if just maintaining connection
      unless tweets =~ /^\n$/
        @buffer << tweets
      end
      while line = @buffer.slice!(/.+\r\n/)
        @tweet_callback.call(line) if @tweet_callback
      end
    end
  end

  def report_error
    puts "Error: stream stopped."
    @error_callback.call if @error_callback
  end
end