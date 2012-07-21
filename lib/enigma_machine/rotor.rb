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

    def position=(letter)
      @position = ALPHABET.index(letter)
    end
    def position
      ALPHABET[@position]
    end

    def advance_position
      @position = (@position + 1).modulo(26)
    end

    def at_notch?
      @notch_positions.include?(self.position)
    end

    def try_advance(previous_at_notch)
      self_at_notch = self.at_notch?
      advance_position if previous_at_notch or self_at_notch
      self_at_notch
    end

    def forward(letter)
      index = add_offset ALPHABET.index(letter)
      new_index = sub_offset @mapping[index]
      ALPHABET[new_index]
    end

    def reverse(letter)
      index = add_offset ALPHABET.index(letter)
      new_index = sub_offset @mapping.index(index)
      ALPHABET[new_index]
    end

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
