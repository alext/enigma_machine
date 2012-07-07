require 'spec_helper'

describe EnigmaMachine::Rotor do

  describe "forward translation" do
    it "translates the input in the forward direction" do
      EnigmaMachine::Rotor.new("BDFH", 0, nil).forward("B").should == "D"
    end

    it "translates the input in the reverse direction" do
      EnigmaMachine::Rotor.new("BDFH", 0, nil).reverse("D").should == "B"
    end

    context "with offset" do
      it "translates the input in the forward direction" do
        EnigmaMachine::Rotor.new("BDFH", 1, nil).forward("B").should == "E"
      end
      it "translates the input in the reverse direction" do
        EnigmaMachine::Rotor.new("BDFH", 1, nil).reverse("E").should == "B"
      end
    end
  end


  describe "decorating a reflector" do
    it "should apply the forward and reverse translation" do
      reflector = stub("Reflector")
      reflector.should_receive(:translate).with('D').and_return('H')

      rotor = EnigmaMachine::Rotor.new("BDFH", 0, reflector)
      rotor.translate('B').should == 'D'
    end
  end
end
