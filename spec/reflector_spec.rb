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

    describe "using one of the standard configurations" do
      it "should raise an error if using an unknown name" do
        lambda do
          EnigmaMachine::Reflector.new(:foo)
        end.should raise_error(EnigmaMachine::ConfigurationError)
      end

      it "should support reflector A" do
        r = EnigmaMachine::Reflector.new(:A)
        r.translate('A').should == 'E'
        r.translate('F').should == 'L'
        r.translate('Q').should == 'O'
      end

      it "should support reflector B" do
        r = EnigmaMachine::Reflector.new(:B)
        r.translate('A').should == 'Y'
        r.translate('F').should == 'S'
        r.translate('Q').should == 'E'
      end

      it "should support reflector C" do
        r = EnigmaMachine::Reflector.new(:C)
        r.translate('A').should == 'F'
        r.translate('K').should == 'R'
        r.translate('Q').should == 'T'
      end

      it "should support reflector Bthin" do
        r = EnigmaMachine::Reflector.new(:Bthin)
        r.translate('A').should == 'E'
        r.translate('F').should == 'U'
        r.translate('P').should == 'M'
      end

      it "should support reflector Cthin" do
        r = EnigmaMachine::Reflector.new(:Cthin)
        r.translate('A').should == 'R'
        r.translate('K').should == 'H'
        r.translate('Q').should == 'Z'
      end
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
