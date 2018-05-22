
RSpec.describe EnigmaMachine::Reflector do

  describe "configuring a reflector" do
    it "should raise an error if passing in anything other than an array of upper case letter pairs" do
      expect do
        EnigmaMachine::Reflector.new(%w(AY BRC U DH EQ FS GL IP JX KN MO TZ VW))
      end.to raise_error(EnigmaMachine::ConfigurationError)

      expect do
        EnigmaMachine::Reflector.new(%w(AY BR cu DH EQ FS GL IP JX KN MO TZ VW))
      end.to raise_error(EnigmaMachine::ConfigurationError)
    end

    it "should raise an error if attempting to connect more than one wire to a letter" do
      expect do
        EnigmaMachine::Reflector.new(%w(AY BR CB DH EQ FS GL IP JX KN MO TZ VW))
      end.to raise_error(EnigmaMachine::ConfigurationError)
    end

    it "should raise an error unless all 26 letters are configured" do
      expect do
        EnigmaMachine::Reflector.new(%w(AY BR CU DH EQ FS GL IP JX KN MO TZ))
      end.to raise_error(EnigmaMachine::ConfigurationError)
    end

    describe "using one of the standard configurations" do
      it "should raise an error if using an unknown name" do
        expect do
          EnigmaMachine::Reflector.new(:foo)
        end.to raise_error(EnigmaMachine::ConfigurationError)
      end

      it "should support reflector A" do
        r = EnigmaMachine::Reflector.new(:A)
        expect(r.translate('A')).to eq('E')
        expect(r.translate('F')).to eq('L')
        expect(r.translate('Q')).to eq('O')
      end

      it "should support reflector B" do
        r = EnigmaMachine::Reflector.new(:B)
        expect(r.translate('A')).to eq('Y')
        expect(r.translate('F')).to eq('S')
        expect(r.translate('Q')).to eq('E')
      end

      it "should support reflector C" do
        r = EnigmaMachine::Reflector.new(:C)
        expect(r.translate('A')).to eq('F')
        expect(r.translate('K')).to eq('R')
        expect(r.translate('Q')).to eq('T')
      end

      it "should support reflector Bthin" do
        r = EnigmaMachine::Reflector.new(:Bthin)
        expect(r.translate('A')).to eq('E')
        expect(r.translate('F')).to eq('U')
        expect(r.translate('P')).to eq('M')
      end

      it "should support reflector Cthin" do
        r = EnigmaMachine::Reflector.new(:Cthin)
        expect(r.translate('A')).to eq('R')
        expect(r.translate('K')).to eq('H')
        expect(r.translate('Q')).to eq('Z')
      end
    end
  end

  describe "translating letters" do
    before :each do
      @reflector = EnigmaMachine::Reflector.new(%w(AY BR CU DH EQ FS GL IP JX KN MO TZ VW))
    end

    it "should substitute a letter that's first in a pair" do
      expect(@reflector.translate('B')).to eq('R')
    end

    it "should substitute a letter that's second in a pair" do
      expect(@reflector.translate('L')).to eq('G')
    end
  end
end
