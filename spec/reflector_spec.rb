require 'spec_helper'

describe Enigma::Reflector do
  it "should reflect characters based on the mapping" do
    Enigma::Reflector.new("BCDEF").translate("B").should == "A"
  end
end
