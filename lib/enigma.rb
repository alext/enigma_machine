class Enigma
  class Reflector
    def initialize(mapping)
      @mapping = mapping
    end

    def translate(input)
      index = @mapping.index( input )
      ALPHABET[index]
    end
  end

  class Rotor
    def initialize(mapping, decorated = nil)
      @mapping = mapping
      @decorated = decorated
    end

    def forward(input)
      index = ALPHABET.index( input )
      @mapping[index]
    end

    def reverse(input)
      index = @mapping.index(input)
      ALPHABET[index]
    end

    def translate(input)
      step = input
      step = forward(step)
      step = @decorated.translate(step)
      step = reverse(step)
      step
    end
  end

  ALPHABET = ('A'..'Z').to_a

  def initialize(left_rotor, center_rotor, right_rotor)
    @reflector = Reflector.new "YRUHQSLDPXNGOKMIEBFZCWVJAT"
    @left_rotor = Rotor.new "EKMFLGDQVZNTOWYHXUSPAIRBCJ", @reflector
    @center_rotor = Rotor.new "AJDKSIRUXBLHWTMCQGZNPYFVOE", @left_rotor
    @right_rotor = Rotor.new "BDFHJLCPRTXVZNYEIWGAKMUSQO", @center_rotor
  end

  def process(message)
    @right_rotor.translate message
  end
end
