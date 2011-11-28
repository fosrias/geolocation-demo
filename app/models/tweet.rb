class Tweet
  include Mongoid::Document

  field :loc,         :type => Array
  field :screen_name, :type => String
  field :text,        :type => String
  field :created_at,  :type => DateTime

  index [ [:loc, Mongo::GEO2D] ], background: true

  def self.coordinates_near(search_location)
     if search_location.empty?
       desc(:created_at)
     else
       where(:loc => {"$near" => search_location}).desc(:created_at)
     end
  end
end
