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

    it "should create a null plugboard if none specified" do
      EnigmaMachine::Reflector.stub!(:new)
      EnigmaMachine::Rotor.stub!(:new)
      EnigmaMachine::Plugboard.should_receive(:new).with([], anything())

      EnigmaMachine.new(:reflector => :foo, :rotors => [[:i, 1], [:ii, 2], [:iii, 3]])
    end
  end

  describe "setting rotor positions" do
    before :each do
      @left_rotor = mock("Rotor")
      @middle_rotor = mock("Rotor")
      @right_rotor = mock("Rotor")
      EnigmaMachine::Rotor.stub!(:new).with(:i, anything(), anything()).and_return(@left_rotor)
      EnigmaMachine::Rotor.stub!(:new).with(:ii, anything(), anything()).and_return(@middle_rotor)
      EnigmaMachine::Rotor.stub!(:new).with(:iii, anything(), anything()).and_return(@right_rotor)
      EnigmaMachine::Reflector.stub!(:new)
      EnigmaMachine::Plugboard.stub!(:new)

      @e = EnigmaMachine.new(:rotors => [[:i,1], [:ii,2], [:iii,3]])
    end

    it "should set the position of each rotor" do
      @left_rotor.should_receive(:position=).with('A')
      @middle_rotor.should_receive(:position=).with('B')
      @right_rotor.should_receive(:position=).with('C')

      @e.set_rotors('A', 'B', 'C')
    end
  end

  describe "processing a message" do
    before :each do
      EnigmaMachine::Reflector.stub!(:new)
      EnigmaMachine::Rotor.stub!(:new)
      EnigmaMachine::Plugboard.stub!(:new)

      @e = EnigmaMachine.new(:rotors => [:a, :b, :c])
      @e.stub!(:press_key).and_return('Z')
    end

    it "should call press_key for each letter in order, and return the results" do
      @e.should_receive(:press_key).with('A').ordered.and_return('B')
      @e.should_receive(:press_key).with('B').ordered.and_return('C')
      @e.should_receive(:press_key).with('C').ordered.and_return('D')

      @e.translate('ABC').should == 'BCD'
    end

    it "should pass through spaces unmodified" do
      @e.should_not_receive(:press_key).with(' ')

      @e.translate('ABC DEF').should == 'ZZZ ZZZ'
    end

    it "should upcase the input before passing to press_key" do
      @e.should_receive(:press_key).with('A').ordered.and_return('B')
      @e.should_receive(:press_key).with('B').ordered.and_return('C')
      @e.should_receive(:press_key).with('C').ordered.and_return('D')

      @e.translate('aBc').should == 'BCD'
    end

    it "should discard any other characters passed in" do
      @e.should_not_receive(:press_key).with(/[^A-Z]/)

      @e.translate('A1B3C.D+E%F123').should == 'ZZZZZZ'
    end
  end

  describe "processing a letter" do
    before :each do
      EnigmaMachine::Reflector.stub!(:new)
      EnigmaMachine::Rotor.stub!(:new)
      @plugboard = mock("Plugboard", :translate => 'B')
      EnigmaMachine::Plugboard.stub!(:new).and_return(@plugboard)

      @e = EnigmaMachine.new(:rotors => [:a, :b, :c])
      @e.stub!(:advance_rotors)
    end

    it "should advance the rotors" do
      @e.should_receive(:advance_rotors)

      @e.press_key('A')
    end

    it "should call translate on the plugboard, and return the result" do
      @plugboard.should_receive(:translate).and_return('F')

      @e.press_key('A').should == 'F'
    end
  end

  describe "advancing rotors" do

  end
end
