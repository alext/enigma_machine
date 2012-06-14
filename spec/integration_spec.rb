require 'spec_helper'

require 'enigma'

describe "Integration tests" do

  specify "An enigma machine set to I-II-III, MCK encodes E to Q" do
    Enigma.new([1, "M"], [2, "C"], [3, "K"]).process("E").should == "Q"
  end

  specify "Encoding the cyphertext of a message with the same settings returns the original message" do
    e = Enigma.new([1, "M"], [2, "C"], [3, "K"])
    e.process("E").should == "Q"
    e = Enigma.new([1, "M"], [2, "C"], [3, "K"])
    e.process("Q").should == "E"
  end

  specify "Encoding the same letter twice returns a different answer" do
    pending
    e = Enigma.new([1, "M"], [2, "C"], [3, "K"])
    e.process("E").should == "Q"
    e.process("E").should_not == "Q"
  end

end
