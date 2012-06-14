require 'spec_helper'

describe Enigma::Rotor do

  describe "forward translation" do

    it "translates the input in the forward direction" do
      Enigma::Rotor.new("BDFH").forward("B").should == "D"
    end

    it "translates the input in the reverse direction" do
      Enigma::Rotor.new("BDFH").reverse("D").should == "B"
    end
  end
end
