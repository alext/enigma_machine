class EnigmaMachine
  class Rotor
    def initialize(mapping, ring_setting, decorated)
      @mapping = mapping.split('_').first
      @ring_offset = ring_setting - 1
      @decorated = decorated
      @position = 'A'
    end

    attr_writer :position

    def forward(letter)
      index = (ALPHABET.index(letter) - rotor_offset).modulo(26)
      new_index = (ALPHABET.index(@mapping[index]) + rotor_offset).modulo(26)
      ALPHABET[new_index]
    end

    def reverse(letter)
      i = (ALPHABET.index(letter) - rotor_offset).modulo(26)
      index = (@mapping.index(ALPHABET[i]) + rotor_offset).modulo(26)
      ALPHABET[index]
    end

    def translate(input)
      step = forward(input)
      step = @decorated.translate(step)
      reverse(step)
    end

    private

    def rotor_offset
      @ring_offset - ALPHABET.index(@position)
    end
  end
end
