require 'spec_helper'

describe EnigmaMachine::Rotor do

  describe "configuring a rotor" do
    describe "using one of the standard configurations" do
      it "should raise an error if using an unknown name" do
        lambda do
          EnigmaMachine::Rotor.new(:foo, 1, :next)
        end.should raise_error(EnigmaMachine::ConfigurationError)
      end

      it "should support rotor i" do
        r = EnigmaMachine::Rotor.new(:i, 1, :next)
        r.forward('A').should == 'E'
        r.forward('Q').should == 'X'
      end

      it "should support rotor ii" do
        r = EnigmaMachine::Rotor.new(:ii, 1, :next)
        r.forward('A').should == 'A'
        r.forward('M').should == 'W'
      end

      it "should support rotor iii" do
        r = EnigmaMachine::Rotor.new(:iii, 1, :next)
        r.forward('A').should == 'B'
        r.forward('Q').should == 'I'
      end

      it "should support rotor iv" do
        r = EnigmaMachine::Rotor.new(:iv, 1, :next)
        r.forward('A').should == 'E'
        r.forward('Q').should == 'N'
      end

      it "should support rotor v" do
        r = EnigmaMachine::Rotor.new(:v, 1, :next)
        r.forward('A').should == 'V'
        r.forward('Q').should == 'A'
      end

      it "should support rotor vi" do
        r = EnigmaMachine::Rotor.new(:vi, 1, :next)
        r.forward('A').should == 'J'
        r.forward('Q').should == 'D'
      end

      it "should support rotor vii" do
        r = EnigmaMachine::Rotor.new(:vii, 1, :next)
        r.forward('A').should == 'N'
        r.forward('Q').should == 'A'
      end

      it "should support rotor viii" do
        r = EnigmaMachine::Rotor.new(:viii, 1, :next)
        r.forward('A').should == 'F'
        r.forward('Q').should == 'A'
      end

      it "should support rotor beta" do
        r = EnigmaMachine::Rotor.new(:beta, 1, :next)
        r.forward('A').should == 'L'
        r.forward('Q').should == 'T'
      end

      it "should support rotor gamma" do
        r = EnigmaMachine::Rotor.new(:gamma, 1, :next)
        r.forward('A').should == 'F'
        r.forward('Q').should == 'W'
      end
    end
  end
  describe "setting and manipulating rotor positions" do
    before :each do
      @rotor = EnigmaMachine::Rotor.new("ABCD", 1, :foo)
    end

    it "should set the position to 'A' by default" do
      @rotor.position.should == 'A'
    end

    it "should allow setting the position" do
      @rotor.position = 'G'
      @rotor.position.should == 'G'
    end

    describe "advancing the position" do
      it "should allow advancing the position" do
        @rotor.advance_position
        @rotor.position.should == 'B'
      end

      it "should wrap around when advancing beyond 'Z'" do
        @rotor.position = 'Z'
        @rotor.advance_position
        @rotor.position.should == 'A'
      end
    end
  end

  describe "forward and reverse translation" do
    context "with a ring-setting of 1 (no adjustment), and a rotor position of A (the default)" do
      before :each do
        @rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 1, :decorated)
      end

      it "should translate letters correctly in the forward direction" do
        @rotor.forward("B").should == "K"
        @rotor.forward("Y").should == "C"
      end

      it "should translate letters correctly in the reverse direction" do
        @rotor.reverse("L").should == "E"
        @rotor.reverse("C").should == "Y"
      end
    end

    context "with a ring-setting of 5, and a rotor position of A (the default)" do
      before :each do
        @rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 5, :decorated)
      end

      it "should translate letters correctly in the forward direction" do
        @rotor.forward("B").should == "V"
        @rotor.forward("U").should == "B"
      end

      it "should translate letters correctly in the reverse direction" do
        @rotor.reverse("F").should == "A"
        @rotor.reverse("C").should == "S"
      end
    end

    context "with a ring-setting of 1 (no adjustment), and a rotor position of L" do
      before :each do
        @rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 1, :decorated)
        @rotor.position = 'L'
      end

      it "should translate letters correctly in the forward direction" do
        @rotor.forward("B").should == "D"
        @rotor.forward("Y").should == "O"
      end

      it "should translate letters correctly in the reverse direction" do
        @rotor.reverse("L").should == "C"
        @rotor.reverse("V").should == "U"
      end
    end

    context "with a ring-setting of 5, and a rotor position of T" do
      before :each do
        @rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 5, :decorated)
        @rotor.position = 'T'
      end

      it "should translate letters correctly in the forward direction" do
        @rotor.forward("B").should == "I"
        @rotor.forward("Y").should == "H"
      end

      it "should translate letters correctly in the reverse direction" do
        @rotor.reverse("L").should == "F"
        @rotor.reverse("V").should == "M"
      end

    end
  end

  describe "decorating a reflector" do
    it "should substitute the letter, pass to the rotor, then substitute the final result" do
      reflector = stub("Reflector")
      reflector.should_receive(:translate).with('D').and_return('H')

      rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 1, reflector)
      rotor.translate('G').should == 'P'
    end
  end
end
