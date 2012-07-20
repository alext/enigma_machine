require 'spec_helper'

describe EnigmaMachine::Reflector do

  describe "configuring a reflector" do
    it "should raise an error if passing in anything other than an array of upper case letter pairs" do
      lambda do
        EnigmaMachine::Reflector.new(%w(AY BRC U DH EQ FS GL IP JX KN MO TZ VW))
      end.should raise_error(EnigmaMachine::ConfigurationError)

      lambda do
        EnigmaMachine::Reflector.new(%w(AY BR cu DH EQ FS GL IP JX KN MO TZ VW))
      end.should raise_error(EnigmaMachine::ConfigurationError)
    end

    it "should raise an error if attempting to connect more than one wire to a letter" do
      lambda do
        EnigmaMachine::Reflector.new(%w(AY BR CB DH EQ FS GL IP JX KN MO TZ VW))
      end.should raise_error(EnigmaMachine::ConfigurationError)
    end

    it "should raise an error unless all 26 letters are configured" do
      lambda do
        EnigmaMachine::Reflector.new(%w(AY BR CU DH EQ FS GL IP JX KN MO TZ))
      end.should raise_error(EnigmaMachine::ConfigurationError)
    end
  end

  describe "translating letters" do
    before :each do
      @reflector = EnigmaMachine::Reflector.new(%w(AY BR CU DH EQ FS GL IP JX KN MO TZ VW))
    end

    it "should substitute a letter that's first in a pair" do
      @reflector.translate('B').should == 'R'
    end

    it "should substitute a letter that's second in a pair" do
      @reflector.translate('L').should == 'G'
    end
  end
end
