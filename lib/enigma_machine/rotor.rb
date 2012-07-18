class EnigmaMachine
  class Rotor
    def initialize(mapping, ring_setting, decorated)
      @mapping = mapping.split('_').first
      @ring_offset = ring_setting - 1
      @decorated = decorated
    end

    def forward(letter)
      index = ALPHABET.index(letter) - @ring_offset
      new_index = ALPHABET.index(@mapping[index]) + @ring_offset
      ALPHABET[new_index]
    end

    def reverse(letter)
      i = ALPHABET.index(letter) - @ring_offset
      index = @mapping.index(ALPHABET[i]) + @ring_offset
      ALPHABET[index]
    end

    def translate(input)
      step = forward(input)
      step = @decorated.translate(step)
      reverse(step)
    end
  end
end
