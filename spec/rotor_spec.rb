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

  describe "decorating a reflector" do
    it "should apply the forward and reverse translation" do
      reflector = stub("Reflector")
      reflector.should_receive(:translate).with('D').and_return('H')

      rotor = Enigma::Rotor.new("BDFH", reflector)
      rotor.translate('B').should == 'D'
    end
  end
end
