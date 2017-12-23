class EnigmaMachine
  class Rotor
    STANDARD_ROTORS = {
      :i      => "EKMFLGDQVZNTOWYHXUSPAIBRCJ_Q",
      :ii     => "AJDKSIRUXBLHWTMCQGZNPYFVOE_E",
      :iii    => "BDFHJLCPRTXVZNYEIWGAKMUSQO_V",
      :iv     => "ESOVPZJAYQUIRHXLNFTGKDCMWB_J",
      :v      => "VZBRGITYUPSDNHLXAWMJQOFECK_Z",
      :vi     => "JPGVOUMFYQBENHZRDKASXLICTW_MZ",
      :vii    => "NZJHGRCXMYSWBOUFAIVLPEKQDT_MZ",
      :viii   => "FKQHTLXOCBJSPDZRAMEWNIUYGV_MZ",
      :beta   => "LEYJVCNIXWPBQMDRTAKZGFUHOS_", # The beta and gamma rotors caould only go 
      :gamma  => "FSOKANUERHMBTIYCWLQPZXVGJD_", # in position 4, and hence have no notches.
    }

    # Construct a new rotor
    #
    # Examples:
    #
    #   Rotor.new(:ii, 12, @next)
    #   Rotor.new("BDFHJLCPRTXVZNYEIWGAKMUSQO_V", 15, @next)
    #
    # When specifying a custom rotor_spec, the letters after the _ indicate the notch positions
    #
    # @param rotor_spec [Symbol, String] A symbol representing one of the standard rotors or
    #   a string specifying the mapping and notch positions (see Examples)
    # @param ring_setting [Integer] The ring setting for the rotor.
    # @param decorated [#translate] The next component in the processing chain (the next rotor, or the reflector)
    # @raise [ConfigurationError] if an invalid rotor_spec is passed in (unrecognised standard rotor)
    def initialize(rotor_spec, ring_setting, decorated)
      if rotor_spec.is_a?(Symbol)
        raise ConfigurationError unless STANDARD_ROTORS.has_key?(rotor_spec)
        rotor_spec = STANDARD_ROTORS[rotor_spec]
      end
      mapping, notch_positions = rotor_spec.split('_', 2)
      @mapping = mapping.each_char.map {|c| ALPHABET.index(c) }
      @notch_positions = notch_positions.split('')
      @ring_offset = ring_setting - 1
      @decorated = decorated
      self.position = 'A'
    end

    # Set the position of the rotor
    #
    # @param letter [String] the letter position to set the rotor to
    # @return [void]
    def position=(letter)
      @position = ALPHABET.index(letter)
    end
    # @return [String] the current position of the rotor
    def position
      ALPHABET[@position]
    end

    # Advance the position of the rotor.
    # @return [void]
    def advance_position
      @position = (@position + 1).modulo(26)
    end

    # Is the rotor currently at a notch position.
    def at_notch?
      @notch_positions.include?(self.position)
    end

    # Perform the forward translation of a letter (i.e. the path towards the reflector)
    #
    # @param letter [String] the letter to be translated
    # @return [String] the translated letter
    def forward(letter)
      index = add_offset ALPHABET.index(letter)
      new_index = sub_offset @mapping[index]
      ALPHABET[new_index]
    end

    # Perform the reverse translation of a letter (i.e. the path returning from the reflector)
    #
    # @param letter [String] the letter to be translated
    # @return [String] the translated letter
    def reverse(letter)
      index = add_offset ALPHABET.index(letter)
      new_index = sub_offset @mapping.index(index)
      ALPHABET[new_index]
    end

    # Translate a letter
    #
    # This performs a forward substitution, calls the next component to do the rest of the translation, and then
    # reverse substitutes the result on the way back out.
    #
    # @param input [String] the letter to be translated
    # @return [String] the translated letter
    def translate(input)
      step = forward(input)
      step = @decorated.translate(step)
      reverse(step)
    end

    private

    def rotor_offset
      @position - @ring_offset
    end

    def add_offset(number)
      (number + rotor_offset).modulo(26)
    end
    def sub_offset(number)
      (number - rotor_offset).modulo(26)
    end
  end
end
