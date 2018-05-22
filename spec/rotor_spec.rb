
RSpec.describe EnigmaMachine::Rotor do

  describe "configuring a rotor" do
    describe "using one of the standard configurations" do
      it "should raise an error if using an unknown name" do
        expect do
          EnigmaMachine::Rotor.new(:foo, 1, :next)
        end.to raise_error(EnigmaMachine::ConfigurationError)
      end

      it "should support rotor i" do
        r = EnigmaMachine::Rotor.new(:i, 1, :next)
        expect(r.forward('A')).to eq('E')
        expect(r.forward('Q')).to eq('X')
        r.position = 'Q'
        expect(r.at_notch?).to eq(true)
      end

      it "should support rotor ii" do
        r = EnigmaMachine::Rotor.new(:ii, 1, :next)
        expect(r.forward('A')).to eq('A')
        expect(r.forward('M')).to eq('W')
        r.position = 'E'
        expect(r.at_notch?).to eq(true)
      end

      it "should support rotor iii" do
        r = EnigmaMachine::Rotor.new(:iii, 1, :next)
        expect(r.forward('A')).to eq('B')
        expect(r.forward('Q')).to eq('I')
        r.position = 'V'
        expect(r.at_notch?).to eq(true)
      end

      it "should support rotor iv" do
        r = EnigmaMachine::Rotor.new(:iv, 1, :next)
        expect(r.forward('A')).to eq('E')
        expect(r.forward('Q')).to eq('N')
        r.position = 'J'
        expect(r.at_notch?).to eq(true)
      end

      it "should support rotor v" do
        r = EnigmaMachine::Rotor.new(:v, 1, :next)
        expect(r.forward('A')).to eq('V')
        expect(r.forward('Q')).to eq('A')
        r.position = 'Z'
        expect(r.at_notch?).to eq(true)
      end

      it "should support rotor vi" do
        r = EnigmaMachine::Rotor.new(:vi, 1, :next)
        expect(r.forward('A')).to eq('J')
        expect(r.forward('Q')).to eq('D')
        r.position = 'M'
        expect(r.at_notch?).to eq(true)
        r.position = 'Z'
        expect(r.at_notch?).to eq(true)
      end

      it "should support rotor vii" do
        r = EnigmaMachine::Rotor.new(:vii, 1, :next)
        expect(r.forward('A')).to eq('N')
        expect(r.forward('Q')).to eq('A')
        r.position = 'M'
        expect(r.at_notch?).to eq(true)
        r.position = 'Z'
        expect(r.at_notch?).to eq(true)
      end

      it "should support rotor viii" do
        r = EnigmaMachine::Rotor.new(:viii, 1, :next)
        expect(r.forward('A')).to eq('F')
        expect(r.forward('Q')).to eq('A')
        r.position = 'M'
        expect(r.at_notch?).to eq(true)
        r.position = 'Z'
        expect(r.at_notch?).to eq(true)
      end

      it "should support rotor beta" do
        r = EnigmaMachine::Rotor.new(:beta, 1, :next)
        expect(r.forward('A')).to eq('L')
        expect(r.forward('Q')).to eq('T')
      end

      it "should support rotor gamma" do
        r = EnigmaMachine::Rotor.new(:gamma, 1, :next)
        expect(r.forward('A')).to eq('F')
        expect(r.forward('Q')).to eq('W')
      end
    end
  end

  describe "setting and manipulating rotor positions" do
    before :each do
      @rotor = EnigmaMachine::Rotor.new(:i, 1, :foo)
    end

    it "should set the position to 'A' by default" do
      expect(@rotor.position).to eq('A')
    end

    it "should allow setting the position" do
      @rotor.position = 'G'
      expect(@rotor.position).to eq('G')
    end

    describe "advancing the position" do
      it "should allow advancing the position" do
        @rotor.advance_position
        expect(@rotor.position).to eq('B')
      end

      it "should wrap around when advancing beyond 'Z'" do
        @rotor.position = 'Z'
        @rotor.advance_position
        expect(@rotor.position).to eq('A')
      end
    end
  end

  describe "checking notch position" do
    it "should return true if the rotor is at one of the notch positions" do
      rotor = EnigmaMachine::Rotor.new('EKMFLGDQVZNTOWYHXUSPAIBRCJ_DR', 1, :foo)

      rotor.position = 'D'
      expect(rotor.at_notch?).to eq(true)

      rotor.position = 'R'
      expect(rotor.at_notch?).to eq(true)
    end

    it "should return false otherwise" do
      rotor = EnigmaMachine::Rotor.new('EKMFLGDQVZNTOWYHXUSPAIBRCJ_DR', 1, :foo)

      rotor.position = 'C'
      expect(rotor.at_notch?).to eq(false)
      rotor.position = 'E'
      expect(rotor.at_notch?).to eq(false)

      rotor.position = 'Q'
      expect(rotor.at_notch?).to eq(false)
      rotor.position = 'S'
      expect(rotor.at_notch?).to eq(false)

      rotor.position = 'A'
      expect(rotor.at_notch?).to eq(false)
    end

    it "should be unaffected by the ring position" do
      rotor = EnigmaMachine::Rotor.new('EKMFLGDQVZNTOWYHXUSPAIBRCJ_DR', 6, :foo)

      rotor.position = 'C'
      expect(rotor.at_notch?).to eq(false)
      rotor.position = 'D'
      expect(rotor.at_notch?).to eq(true)
      rotor.position = 'E'
      expect(rotor.at_notch?).to eq(false)

      rotor.position = 'Q'
      expect(rotor.at_notch?).to eq(false)
      rotor.position = 'R'
      expect(rotor.at_notch?).to eq(true)
      rotor.position = 'S'
      expect(rotor.at_notch?).to eq(false)
    end
  end

  describe "forward and reverse translation" do
    context "with a ring-setting of 1 (no adjustment), and a rotor position of A (the default)" do
      before :each do
        @rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 1, :decorated)
      end

      it "should translate letters correctly in the forward direction" do
        expect(@rotor.forward("B")).to eq("K")
        expect(@rotor.forward("Y")).to eq("C")
      end

      it "should translate letters correctly in the reverse direction" do
        expect(@rotor.reverse("L")).to eq("E")
        expect(@rotor.reverse("C")).to eq("Y")
      end
    end

    context "with a ring-setting of 5, and a rotor position of A (the default)" do
      before :each do
        @rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 5, :decorated)
      end

      it "should translate letters correctly in the forward direction" do
        expect(@rotor.forward("B")).to eq("V")
        expect(@rotor.forward("U")).to eq("B")
      end

      it "should translate letters correctly in the reverse direction" do
        expect(@rotor.reverse("F")).to eq("A")
        expect(@rotor.reverse("C")).to eq("S")
      end
    end

    context "with a ring-setting of 1 (no adjustment), and a rotor position of L" do
      before :each do
        @rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 1, :decorated)
        @rotor.position = 'L'
      end

      it "should translate letters correctly in the forward direction" do
        expect(@rotor.forward("B")).to eq("D")
        expect(@rotor.forward("Y")).to eq("O")
      end

      it "should translate letters correctly in the reverse direction" do
        expect(@rotor.reverse("L")).to eq("C")
        expect(@rotor.reverse("V")).to eq("U")
      end
    end

    context "with a ring-setting of 5, and a rotor position of T" do
      before :each do
        @rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 5, :decorated)
        @rotor.position = 'T'
      end

      it "should translate letters correctly in the forward direction" do
        expect(@rotor.forward("B")).to eq("I")
        expect(@rotor.forward("Y")).to eq("H")
      end

      it "should translate letters correctly in the reverse direction" do
        expect(@rotor.reverse("L")).to eq("F")
        expect(@rotor.reverse("V")).to eq("M")
      end

    end
  end

  describe "decorating a reflector" do
    it "should substitute the letter, pass to the rotor, then substitute the final result" do
      reflector = double("Reflector")
      expect(reflector).to receive(:translate).with('D').and_return('H')

      rotor = EnigmaMachine::Rotor.new("EKMFLGDQVZNTOWYHXUSPAIBRCJ_R", 1, reflector)
      expect(rotor.translate('G')).to eq('P')
    end
  end
end
