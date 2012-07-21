class EnigmaMachine
  ConfigurationError = Class.new(StandardError)

  ALPHABET = ('A'..'Z').to_a

  def initialize(config)
    @reflector = Reflector.new config[:reflector]
    @rotors = []
    config[:rotors].inject(@reflector) do |previous, rotor_config|
      Rotor.new(*rotor_config, previous).tap {|r| @rotors << r }
    end
    @plugboard = Plugboard.new(config[:plug_pairs] || [], @rotors.last)
  end

  def set_rotors(*positions)
    positions.each_with_index do |position, i|
      @rotors[i].position = position
    end
  end

  def press_key(letter)
    advance_rotors
    @plugboard.translate(letter)
  end

  def translate(message)
    message.upcase.each_char.map do |letter|
      case letter
      when /[A-Z]/
        press_key(letter)
      when ' '
        ' '
      end
    end.join
  end

  private

  def advance_rotors
  end
end

require 'enigma_machine/version'
require 'enigma_machine/plugboard'
require 'enigma_machine/rotor'
require 'enigma_machine/reflector'
