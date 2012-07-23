class EnigmaMachine
  ConfigurationError = Class.new(StandardError)

  ALPHABET = ('A'..'Z').to_a

  # Constructs an enigma machine with given reflector, rotors and plugboard settings.
  #
  # Examples:
  #
  # You can use the standard reflectors and rotors:
  #
  #   EnigmaMachine.new(
  #     :reflector => :B,
  #     :rotors => [[:i, 10], [:ii, 14], [:iii, 21]],
  #     :plug_pairs => %w(AP BR CM FZ GJ IL NT OV QS WX)
  #   )
  #
  # Or you can use custom reflector and rotor configurations:
  #
  #   EnigmaMachine.new(
  #     :reflector => %w(AF BV CP DJ EI GO HY KR LZ MX NW TQ SU),
  #     :rotors => [
  #       ['BDFHJLCPRTXVZNYEIWGAKMUSQO_V', 10],
  #       ['JPGVOUMFYQBENHZRDKASXLICTW_MZ', 14],
  #       ['ABCDEFGHIJKLMNOPQRSTUVWXYZ_AHT', 21]
  #     ],
  #     :plug_pairs => %w(AP BR CM FZ GJ IL NT OV QS WX)
  #   )
  #
  # When specifying a custom rotor, the letters after the _ indicate the notch positions.
  #
  # @param config [Hash] A Hash of configuration params
  # @option config [Symbol,Array<String>] :reflector Which reflector to use.  Reference one of the
  #   standard ones by Symbol, or pass in an array of
  #   letter pairs for a custom configuration.
  # @option config [Array<Array>] :rotors Array of details for 3 or more rotors.  Specified from
  #   left to right. Each one is specified as a tuple of the rotor spec,
  #   and ring setting.  The rotor_spec can be one of the standard rotors
  #   referenced by Symbol, or a custom rotor described by a config string
  #   (see Examples).
  # @option config [Array<String>] :plug_pairs an Optional array of letter pairs specifying the plugboard
  #   configuration.  If omitted, no plugboard substitutions will be performed.
  #
  # @raise [ConfigurationError] if an invalid configuration was specified
  def initialize(config)
    @reflector = Reflector.new config[:reflector]
    @rotors = []
    config[:rotors].inject(@reflector) do |previous, rotor_config|
      Rotor.new(*rotor_config, previous).tap {|r| @rotors << r }
    end
    @plugboard = Plugboard.new(config[:plug_pairs] || [], @rotors.last)
  end

  # Set the rotors to the given positions.
  #
  # Pass in Positions for the rotors from left to right
  #
  # @param positions [*String] the positions to set the rotors to
  # @return [void]
  def set_rotors(*positions)
    positions.each_with_index do |position, i|
      @rotors[i].position = position
    end
  end

  # Simulates pressing a given key on the machine keyboard.
  #
  # Advances the rotors, and then translates the letter
  #
  # @param letter [String] the letter to be translated
  # @return [String] the translated letter
  def press_key(letter)
    advance_rotors
    @plugboard.translate(letter)
  end

  # Translates the given message using the current settings
  #
  # This will pass through space and - unmodified, and discard any other non-alpha characters.
  #
  # @param message [String] the message to be translated
  # @return [String] the translated message
  def translate(message)
    message.upcase.each_char.map do |letter|
      case letter
      when /[A-Z]/
        press_key(letter)
      when /[ -]/
        letter
      end
    end.join
  end

  private

  def advance_rotors
    @rotors[-3].advance_position if @rotors[-2].at_notch?
    @rotors[-2].advance_position if @rotors[-2].at_notch? or @rotors[-1].at_notch?
    @rotors[-1].advance_position
  end
end

require 'enigma_machine/version'
require 'enigma_machine/plugboard'
require 'enigma_machine/rotor'
require 'enigma_machine/reflector'
