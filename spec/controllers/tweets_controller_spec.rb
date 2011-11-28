require 'spec_helper'

describe TweetsController do

  describe "GET index" do
    describe "without search parameters" do
      it "assigns all tweets as tweets" do
        get :index
        should_expose(:tweets).as([])
      end
    end

    describe "with search parameters" do
      let(:tweet) {Tweet.create!({:loc => [123.1, -45], :screen_name => '@schrute',
                                  :text => "Bears ...", :created_at => Time.now}) }

      it "assigns all tweets as tweets" do
        get :index, :longitude => 122, :latitude => -44
        should_expose(:tweets).as([tweet])
      end
    end

    describe "with invalid search parameters" do
      it "has errors" do
        get :index, :longitude => "a"
        should_expose(:tweets).as([])
      end
    end
  end
end
