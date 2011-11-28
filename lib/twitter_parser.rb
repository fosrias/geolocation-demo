class TwitterParser

  def initialize(show_timestamps=false)
    @show_timestamps = show_timestamps
    @now = Time.now
    @sum = 0
    @counter = 0
  end

  def parse_for(name, tweet)
    Fiber.new do

      if parsed_tweet = self.send("parse_with_#{name}", tweet)
        @on_parse_callback.call(parsed_tweet) if @on_parse_callback
        timestamp if @show_timestamps
      end
    end.resume
  end

  def on_parse(&block)
    @on_parse_callback = block
  end

  private

  # Parses tweets to contain desired geolocation data for batch database inserts
  def parse_with_geolocations(tweet)
    begin
      json = JSON.parse(tweet)
    rescue
      #ignore malformed tweet
    end
    if json && json['geo']
      {:loc => json['geo']['coordinates'], :text => json['text'], :created_at => Time.parse(json['created_at']),
       :screen_name => "@#{json['user']['screen_name']}"}
    end
  end

  def timestamp
    @counter +=1
    seconds = Time.now - @now
    @sum += 1/seconds
    puts "Time: #{seconds}s. Records per second: #{@sum/@counter}."
    @now = Time.now
    if seconds > 10
      @counter = 0
      @sum = 0
    end
  end
end