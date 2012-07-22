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

    class Letter

      def initialize(letter_or_position)
        case letter_or_position
        when Letter
          @value = letter_or_position.to_i
        when String
          @value = letter_or_position.ord - 'A'.ord
        when Integer
          @value = letter_or_position.modulo(26)
        else
          raise ArgumentError
        end
      end

      def to_i
        @value
      end

      def to_s
        (@value + 'A'.ord).chr
      end

      def ==(other)
        other.is_a?(self.class) and other.to_i == @value
      end

      def +(value)
        self.class.new (@value + value.to_i).modulo(26)
      end

      def -(value)
        self.class.new (@value - value.to_i).modulo(26)
      end
    end

    def initialize(rotor_spec, ring_setting, decorated)
      if rotor_spec.is_a?(Symbol)
        raise ConfigurationError unless STANDARD_ROTORS.has_key?(rotor_spec)
        rotor_spec = STANDARD_ROTORS[rotor_spec]
      end
      mapping, notch_positions = rotor_spec.split('_', 2)
      @mapping = mapping.each_char.map {|c| Letter.new(c) }
      @notch_positions = notch_positions.split('')
      @ring_offset = ring_setting - 1
      @decorated = decorated
      self.position = 'A'
    end

    def position=(letter)
      @position = Letter.new(letter)
    end
    def position
      @position.to_s
    end

    def advance_position
      @position += 1
    end

    def at_notch?
      @notch_positions.include?(self.position)
    end

    def forward(letter)
      index = Letter.new(letter) + rotor_offset
      new_letter = @mapping[index.to_i] - rotor_offset
      new_letter.to_s
    end

    def reverse(letter)
      index = Letter.new(letter) + rotor_offset
      new_letter = Letter.new(@mapping.index(index)) - rotor_offset
      new_letter.to_s
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
  end
end
