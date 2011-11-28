class TweetsController < ApplicationController
  before_filter :parse_coordinates

  expose(:search) { has_search_params? ? CoordinateSearch.new(params) : CoordinateSearch.new }
  expose(:tweets) { has_search_params? && search.valid? ? Tweet.coordinates_near(search.location).limit(50) : []  }

  def index
    flash[:alert] = "Please correct the following:" unless search.valid?
  end

  def coordinate_search
    redirect_to tweets_path << search.params
  end

  private

  def has_search_params?
    params[:coordinate_search] || params[:longitude] || params[:latitude]
  end

  def parse_coordinates
    params[:coordinate_search].each { |k, v| params[k] = v } if params[:coordinate_search]
  end
end
