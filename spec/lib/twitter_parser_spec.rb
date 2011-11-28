require 'spec_helper'

describe TwitterParser do
    subject { TwitterParser.new }

    it "should parse tweets" do
      subject.on_parse do |tweet|
        tweet[:screen_name].should == '@MZwatchDIS'
        tweet[:text].should =='@LA_DIMPLES85 always lol wat u wearing? im undecided yet :('
        tweet[:created_at].should == "2011-11-26 17:16:02 -0800"
        tweet[:loc].should == [34.50823231,-82.68388223]
      end
      subject.parse_for :geolocations, stream
    end
end