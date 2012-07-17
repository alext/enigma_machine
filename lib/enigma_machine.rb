class EnigmaMachine
  ConfigurationError = Class.new(StandardError)
  class Reflector
    def initialize(mapping)
      @mapping = mapping
    end

    def translate(input)
      index = @mapping.index( input )
      ALPHABET[index]
    end
  end

  ALPHABET = ('A'..'Z').to_a

  def initialize(left_rotor, center_rotor, right_rotor)
    @reflector = Reflector.new "YRUHQSLDPXNGOKMIEBFZCWVJAT"
    @left_rotor = Rotor.new "EKMFLGDQVZNTOWYHXUSPAIRBCJ", 0, @reflector
    @center_rotor = Rotor.new "AJDKSIRUXBLHWTMCQGZNPYFVOE", 0, @left_rotor
    @right_rotor = Rotor.new "BDFHJLCPRTXVZNYEIWGAKMUSQO", 0, @center_rotor
  end

  def process(message)
    @right_rotor.translate message
  end
end

require 'enigma_machine/version'
require 'enigma_machine/plugboard'
require 'enigma_machine/rotor'
