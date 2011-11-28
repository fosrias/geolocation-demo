class CoordinateSearch
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_reader :longitude, :latitude

  validates_presence_of :longitude, :latitude,   :unless => :has_no_coordinates?
  validates_numericality_of :longitude, :greater_than_or_equal_to => -180,
                                    :less_than_or_equal_to => 180,
                                    :unless => :has_no_coordinates?
  validates_numericality_of :latitude,  :greater_than_or_equal_to => -90,
                                    :less_than_or_equal_to => 90,
                                    :unless => :has_no_coordinates?

  def initialize(opts={})
    @latitude = opts[:latitude].presence
    @longitude = opts[:longitude].presence
  end

  def persisted?
    false
  end

  def location
    @location ||= valid? && has_both_coordinates? ? [latitude.to_f, longitude.to_f] : []
  end

  def params
    return @params if @params
    @params = [:latitude, :longitude]. inject("") do |result, attr|
      result << "&" if !result.empty? && has_both_coordinates?
      result << "#{attr}=#{escaped(self[attr])}" if self[attr]
      result
    end
    @params.empty? ? "" : "?" << @params
  end

  def [](attr)
    send("#{attr}")
  end

  def has_no_coordinates?
    !(longitude || latitude)
  end

  def has_both_coordinates?
    longitude && latitude
  end

  private

  def escaped(s)
    ERB::Util.url_encode(s)
  end
end