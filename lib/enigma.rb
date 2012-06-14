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
    def initialize(mapping, offset, decorated)
      @mapping = mapping
      @offset = offset
      @decorated = decorated
    end

    def forward(input)
      index = ALPHABET.index( input ) + @offset
      step = @mapping[index]
      index = ALPHABET.index( step ) - @offset
      ALPHABET[index]
    end

    def reverse(input)
      index = ALPHABET.index(input) + @offset
      step = ALPHABET[index]
      index = @mapping.index(step)
      ALPHABET[index - @offset]
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
    @left_rotor = Rotor.new "EKMFLGDQVZNTOWYHXUSPAIRBCJ", 0, @reflector
    @center_rotor = Rotor.new "AJDKSIRUXBLHWTMCQGZNPYFVOE", 0, @left_rotor
    @right_rotor = Rotor.new "BDFHJLCPRTXVZNYEIWGAKMUSQO", 0, @center_rotor
  end

  def process(message)
    @right_rotor.translate message
  end
end
