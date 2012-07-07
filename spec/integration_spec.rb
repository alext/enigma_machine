require 'spec_helper'

describe "Integration tests" do

  specify "An enigma machine set to I-II-III, MCK encodes E to Q" do
    pending
    EnigmaMachine.new([1, "M"], [2, "C"], [3, "K"]).process("E").should == "Q"
  end

  specify "Encoding the cyphertext of a message with the same settings returns the original message" do
    pending
    e = EnigmaMachine.new([1, "M"], [2, "C"], [3, "K"])
    e.process("E").should == "Q"
    e = EnigmaMachine.new([1, "M"], [2, "C"], [3, "K"])
    e.process("Q").should == "E"
  end

  specify "Encoding the same letter twice returns a different answer" do
    pending
    e = EnigmaMachine.new([1, "M"], [2, "C"], [3, "K"])
    e.process("E").should == "Q"
    e.process("E").should_not == "Q"
  end

  context "with no rotor offset" do
    specify "An enigma machine set to I-II-III, MCK encodes E to Q" do
      EnigmaMachine.new([1, "A"], [2, "A"], [3, "A"]).process("E").should == "B"
    end

    specify "Encoding the cyphertext of a message with the same settings returns the original message" do
      e = EnigmaMachine.new([1, "A"], [2, "A"], [3, "A"])
      e.process("E").should == "B"
      e = EnigmaMachine.new([1, "A"], [2, "A"], [3, "A"])
      e.process("B").should == "E"
    end

  end
end
