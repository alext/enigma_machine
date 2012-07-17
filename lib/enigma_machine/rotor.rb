class EnigmaMachine
  class Rotor
    def initialize(mapping, ring_setting, decorated)
      @mapping = mapping
      @decorated = decorated
    end

    def forward(letter)
      index = ALPHABET.index(letter)
      @mapping[index]
    end

    def reverse(letter)
      index = @mapping.index(letter)
      ALPHABET[index]
    end

    def translate(input)
      step = forward(input)
      step = @decorated.translate(step)
      reverse(step)
    end
  end
end
