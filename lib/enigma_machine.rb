class EnigmaMachine
  ConfigurationError = Class.new(StandardError)

  ALPHABET = ('A'..'Z').to_a

  def initialize(config)
    @reflector = Reflector.new config[:reflector]
    @rotors = []
    config[:rotors].inject(@reflector) do |previous, rotor_config|
      Rotor.new(*rotor_config, previous).tap {|r| @rotors << r }
    end
    @plugboard = Plugboard.new(config[:plug_pairs], @rotors.last)
  end

  def process(message)
    @right_rotor.translate message
  end
end

require 'enigma_machine/version'
require 'enigma_machine/plugboard'
require 'enigma_machine/rotor'
require 'enigma_machine/reflector'
