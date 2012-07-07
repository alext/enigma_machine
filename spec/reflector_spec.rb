require 'spec_helper'

describe EnigmaMachine::Reflector do
  it "should reflect characters based on the mapping" do
    EnigmaMachine::Reflector.new("BCDEF").translate("B").should == "A"
  end
end
