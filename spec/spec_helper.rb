# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:suite) do
    db = Mongo::Connection.new.db('geoloc_test')
    db.collection("tweets").drop() if db.collection_names.include?('tweets')
    tweets_collection = db.create_collection('tweets', {capped: true, size: 100000})
    tweets_collection.create_index([['loc', Mongo::GEO2D]])
  end
end

def should_expose(name)
  value = controller.send(name)
  value.should_not be_nil
  Class.new do
    def initialize(exposed)
      @exposed = exposed
    end

    def as(value)
      @exposed.should == value
    end
  end.new(value)
end
