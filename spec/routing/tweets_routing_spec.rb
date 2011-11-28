require "spec_helper"

describe TweetsController do
  describe "routing" do

    it "routes to #index" do
      get("/tweets").should route_to("tweets#index")
    end

    it "routes to #search" do
      post("/tweets/search").should route_to("tweets#coordinate_search")
    end
  end
end
