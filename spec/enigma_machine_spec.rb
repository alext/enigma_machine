require 'spec_helper'

describe EnigmaMachine do

  describe "creating an instance" do
    it "should construct the reflector, rotors and plug_board and connect them together" do
      EnigmaMachine::Reflector.should_receive(:new).with(:foo).and_return(:reflector)
      EnigmaMachine::Rotor.should_receive(:new).with(:i, 1, :reflector).and_return(:left_rotor)
      EnigmaMachine::Rotor.should_receive(:new).with(:ii, 2, :left_rotor).and_return(:middle_rotor)
      EnigmaMachine::Rotor.should_receive(:new).with(:iii, 3, :middle_rotor).and_return(:right_rotor)
      EnigmaMachine::Plugboard.should_receive(:new).with([1,2,3], :right_rotor).and_return(:plugboard)

      EnigmaMachine.new(:reflector => :foo, :rotors => [[:i, 1], [:ii, 2], [:iii, 3]], :plug_pairs => [1,2,3])
    end
  end

  describe "setting rotor positions" do

  end

  describe "processing a message" do

  end

  describe "processing a letter" do

  end

  describe "advancing rotors" do

  end
end
