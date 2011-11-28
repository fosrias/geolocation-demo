require 'spec_helper'

describe CoordinateSearch do

  def search(opts={})
    @search = CoordinateSearch.new(opts)
  end

  describe "#params" do
    it "should include longitude only" do
      search(:longitude => 123)
      @search.params.should == "?longitude=123"
    end

    it "should include latitude only" do
      search(:latitude => -45)
      @search.params.should == "?latitude=-45"
    end

    it "should include longitude and latitude" do
      search(:latitude => -45, :longitude => 123)
      @search.params.should == "?latitude=-45&longitude=123"
    end
  end

  describe "#location" do
    it "should be the coordinates " do
      search(:latitude => -45, :longitude => 123)
      @search.location.should == [-45.0, 123.0]
    end

    it "should be empty without coordinates " do
      search
      @search.location.should == []
    end
  end

  context "validations" do
    it "should accept numerical coordinates" do
      search(:longitude => 123, :latitude => -45)
      @search.should_not have_no_coordinates
      @search.should be_valid
    end

    it "should require numbers" do
      search(:longitude => 'a', :latitude => -45)
      @search.should_not have_no_coordinates
      @search.should have_both_coordinates
      @search.should_not be_valid
    end

    it "should require both coordinates" do
      search(:latitude => -45)
      @search.should_not have_no_coordinates
      @search.should_not be_valid
    end

    it "should allow no coordinates" do
      search
      @search.should have_no_coordinates
      @search.should be_valid
    end
  end
end