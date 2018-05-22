
RSpec.describe EnigmaMachine do

  describe "creating an instance" do
    it "should construct the reflector, rotors and plug_board and connect them together" do
      expect(EnigmaMachine::Reflector).to receive(:new).with(:foo).and_return(:reflector)
      expect(EnigmaMachine::Rotor).to receive(:new).with(:i, 1, :reflector).and_return(:left_rotor)
      expect(EnigmaMachine::Rotor).to receive(:new).with(:ii, 2, :left_rotor).and_return(:middle_rotor)
      expect(EnigmaMachine::Rotor).to receive(:new).with(:iii, 3, :middle_rotor).and_return(:right_rotor)
      expect(EnigmaMachine::Plugboard).to receive(:new).with([1,2,3], :right_rotor).and_return(:plugboard)

      EnigmaMachine.new(:reflector => :foo, :rotors => [[:i, 1], [:ii, 2], [:iii, 3]], :plug_pairs => [1,2,3])
    end

    it "should create a null plugboard if none specified" do
      allow(EnigmaMachine::Reflector).to receive(:new)
      allow(EnigmaMachine::Rotor).to receive(:new)
      expect(EnigmaMachine::Plugboard).to receive(:new).with([], anything())

      EnigmaMachine.new(:reflector => :foo, :rotors => [[:i, 1], [:ii, 2], [:iii, 3]])
    end
  end

  describe "setting rotor positions" do
    before :each do
      @left_rotor = double("Rotor")
      @middle_rotor = double("Rotor")
      @right_rotor = double("Rotor")
      allow(EnigmaMachine::Rotor).to receive(:new).with(:i, anything(), anything()).and_return(@left_rotor)
      allow(EnigmaMachine::Rotor).to receive(:new).with(:ii, anything(), anything()).and_return(@middle_rotor)
      allow(EnigmaMachine::Rotor).to receive(:new).with(:iii, anything(), anything()).and_return(@right_rotor)
      allow(EnigmaMachine::Reflector).to receive(:new)
      allow(EnigmaMachine::Plugboard).to receive(:new)

      @e = EnigmaMachine.new(:rotors => [[:i,1], [:ii,2], [:iii,3]])
    end

    it "should set the position of each rotor" do
      expect(@left_rotor).to receive(:position=).with('A')
      expect(@middle_rotor).to receive(:position=).with('B')
      expect(@right_rotor).to receive(:position=).with('C')

      @e.set_rotors('A', 'B', 'C')
    end
  end

  describe "processing a message" do
    before :each do
      allow(EnigmaMachine::Reflector).to receive(:new)
      allow(EnigmaMachine::Rotor).to receive(:new)
      allow(EnigmaMachine::Plugboard).to receive(:new)

      @e = EnigmaMachine.new(:rotors => [[:i, 1], [:ii, 1], [:iii, 1]])
      allow(@e).to receive(:press_key).and_return('Z')
    end

    it "should call press_key for each letter in order, and return the results" do
      expect(@e).to receive(:press_key).with('A').ordered.and_return('B')
      expect(@e).to receive(:press_key).with('B').ordered.and_return('C')
      expect(@e).to receive(:press_key).with('C').ordered.and_return('D')

      expect(@e.translate('ABC')).to eq('BCD')
    end

    it "should pass through spaces and dashes unmodified" do
      expect(@e).not_to receive(:press_key).with(' ')
      expect(@e).not_to receive(:press_key).with('-')

      expect(@e.translate('ABCDE F----')).to eq('ZZZZZ Z----')
    end

    it "should upcase the input before passing to press_key" do
      expect(@e).to receive(:press_key).with('A').ordered.and_return('B')
      expect(@e).to receive(:press_key).with('B').ordered.and_return('C')
      expect(@e).to receive(:press_key).with('C').ordered.and_return('D')

      expect(@e.translate('aBc')).to eq('BCD')
    end

    it "should discard any other characters passed in" do
      expect(@e).not_to receive(:press_key).with(/[^A-Z]/)

      expect(@e.translate('A1B3C.D+E%F123')).to eq('ZZZZZZ')
    end
  end

  describe "processing a letter" do
    before :each do
      allow(EnigmaMachine::Reflector).to receive(:new)
      allow(EnigmaMachine::Rotor).to receive(:new)
      @plugboard = double("Plugboard", :translate => 'B')
      allow(EnigmaMachine::Plugboard).to receive(:new).and_return(@plugboard)

      @e = EnigmaMachine.new(:rotors => [[:i, 1], [:ii, 1], [:iii, 1]])
      allow(@e).to receive(:advance_rotors)
    end

    it "should advance the rotors" do
      expect(@e).to receive(:advance_rotors)

      @e.press_key('A')
    end

    it "should call translate on the plugboard, and return the result" do
      expect(@plugboard).to receive(:translate).and_return('F')

      expect(@e.press_key('A')).to eq('F')
    end
  end

  describe "advancing rotors" do
    before :each do
      @left_rotor = double("Rotor", :at_notch? => false, :advance_position => nil)
      @middle_rotor = double("Rotor", :at_notch? => false, :advance_position => nil)
      @right_rotor = double("Rotor", :at_notch? => false, :advance_position => nil)
      allow(EnigmaMachine::Rotor).to receive(:new).with(:i, anything(), anything()).and_return(@left_rotor)
      allow(EnigmaMachine::Rotor).to receive(:new).with(:ii, anything(), anything()).and_return(@middle_rotor)
      allow(EnigmaMachine::Rotor).to receive(:new).with(:iii, anything(), anything()).and_return(@right_rotor)
      allow(EnigmaMachine::Reflector).to receive(:new)
      allow(EnigmaMachine::Plugboard).to receive(:new)

      @e = EnigmaMachine.new(:rotors => [[:i,1], [:ii,2], [:iii,3]])
    end

    describe "right rotor" do
      it "should be advanced every time" do
        expect(@right_rotor).to receive(:advance_position)
        @e.send(:advance_rotors)
      end
    end

    describe "middle rotor" do
      it "should be advanced if the right rotor is at a notch" do
        allow(@right_rotor).to receive(:at_notch?).and_return(true)
        expect(@middle_rotor).to receive(:advance_position)

        @e.send(:advance_rotors)
      end

      it "should be advanced if it is at a notch" do
        allow(@middle_rotor).to receive(:at_notch?).and_return(true)
        expect(@middle_rotor).to receive(:advance_position)

        @e.send(:advance_rotors)
      end

      it "should not be advanced otherwise" do
        expect(@middle_rotor).not_to receive(:advance_position)

        @e.send(:advance_rotors)
      end
    end

    describe "left rotor" do
      it "should be advanced if the middle rotor is at a notch" do
        allow(@middle_rotor).to receive(:at_notch?).and_return(true)
        expect(@left_rotor).to receive(:advance_position)

        @e.send(:advance_rotors)
      end

      it "should not be advanced if it is at a notch" do
        allow(@left_rotor).to receive(:at_notch?).and_return(true)
        expect(@left_rotor).not_to receive(:advance_position)

        @e.send(:advance_rotors)
      end

      it "should not be advanced otherwise" do
        expect(@left_rotor).not_to receive(:advance_position)

        @e.send(:advance_rotors)
      end
    end

    describe "4th rotor (when present)" do
      before :each do
        @fourth_rotor = double("Rotor", :at_notch? => false, :advance_position => nil)
        @e.instance_variable_get('@rotors').unshift(@fourth_rotor)
      end

      it "should never be advanced" do
        allow(@fourth_rotor).to receive(:at_notch?).and_return(true)
        allow(@left_rotor).to receive(:at_notch?).and_return(true)
        expect(@fourth_rotor).not_to receive(:advance_position)

        @e.send(:advance_rotors)
      end
    end
  end
end
