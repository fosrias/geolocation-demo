require 'eventmachine'
require 'em-http'
require 'twitter_stream'
require 'twitter_parser'

namespace :twitter do
  desc 'Starts Twitter Streaming API'
  task :stream => :environment do
    username, password = ENV['CREDENTIALS'].split(',') if ENV['CREDENTIALS']
    if username && password

      require 'tweet' # Using rails environment

      # Open db connection
      db = Mongo::Connection.new.db('geoloc_development')

      # Create capped collection if it does not exist
      unless db.collection_names.include?('tweets')
        tweets_collection = db.create_collection('tweets', {capped: true, size: 100000})
        tweets_collection.create_index([['loc', Mongo::GEO2D]])
      end

      EM.run {

        Fiber.new do
          stream = TwitterStream.new(username, password, :locations => '-180,-90,180,90')
          parser = TwitterParser.new(ENV["TIMESTAMPS"])

          stream.on_tweet do |tweet|
            parser.parse_for :geolocations, tweet
          end

          stream.on_error do
            EM.stop
          end

          parser.on_parse do |tweets|
            Tweet.collection.insert(tweets) # Wrapped in a fiber in  parser#parse_for
          end
        end.resume
      }
    else
      puts 'You must provide a username and password for a valid Twitter account.
            E.g. rake twitter:stream CREDENTIALS=username,password (no spaces).'
    end
  end
end