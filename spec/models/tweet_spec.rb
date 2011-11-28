require 'spec_helper'

describe Tweet do
  describe "#coordinates_near" do
    let(:tweet) { mock('tweet') }

    describe "with coordinates" do
      it "should return filtered tweets" do
        @proxy = mock('association_proxy')
        Tweet.should_receive(:where).with(:loc => {"$near" => [1, 2]}).and_return(@proxy)
        @proxy.should_receive(:desc).with(:created_at).and_return([tweet])
        Tweet.coordinates_near([1,2]).should == [tweet]
      end
    end

    describe "without coordinates" do
      it "should return all tweets" do
        Tweet.should_receive(:desc).with(:created_at).and_return([tweet])
        Tweet.coordinates_near([]).should == [tweet]
      end
    end
  end
end
