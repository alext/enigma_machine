
RSpec.describe EnigmaMachine::Plugboard do

  describe "configuring a plugboard" do
    it "should raise an error if passing in anything other than an array of upper case letter pairs" do
      expect do
        EnigmaMachine::Plugboard.new(%w(AB CDE FG), :decorated)
      end.to raise_error(EnigmaMachine::ConfigurationError)

      expect do
        EnigmaMachine::Plugboard.new(%w(AB cd FG), :decorated)
      end.to raise_error(EnigmaMachine::ConfigurationError)
    end

    it "should raise an error if attempting to connect more than one wire to a letter" do
      expect do
        EnigmaMachine::Plugboard.new(%w(AB CD GC), :decorated)
      end.to raise_error(EnigmaMachine::ConfigurationError)
    end
  end

  describe "substituting a letter" do
    before :each do
      @p = EnigmaMachine::Plugboard.new(%w(AF DG EX), :decorated)
    end

    it "should substitute a letter that has a plug wire connected" do
      expect(@p.substitute('D')).to eq('G')
    end

    it "should substitute a letter that's on the other end of the wire" do
      expect(@p.substitute('X')).to eq('E')
    end

    it "should pass through a letter that doesn't have a plug wire connected" do
      expect(@p.substitute('C')).to eq('C')
    end
  end

  describe "decorating a rotor" do
    it "should substitute the latter, pass to the rotor, then substiture the final result" do
      rotor = double("Rotor")
      expect(rotor).to receive(:translate).with('F').and_return('H')

      plugboard = EnigmaMachine::Plugboard.new(%w(AF DG EX ZH), rotor)
      expect(plugboard.translate('A')).to eq('Z')
    end
  end
end
