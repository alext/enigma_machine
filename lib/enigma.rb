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
    def initialize(mapping)
      @mapping = mapping
    end

    def forward(input)
      index = ALPHABET.index( input )
      @mapping[index]
    end

    def reverse(input)
      index = @mapping.index(input)
      ALPHABET[index]
    end
  end

  ALPHABET = ('A'..'Z').to_a

  def initialize(left_rotor, center_rotor, right_rotor)
    @translator = { "E" => "Q", "Q" => "E" }
    @reverse_translation  = { "N" => "C", 'W' => 'E' }
    @left_rotor = Rotor.new "EKMFLGDQVZNTOWYHXUSPAIRBCJ"
    @center_rotor = Rotor.new "AJDKSIRUXBLHWTMCQGZNPYFVOE"
    @right_rotor = Rotor.new "BDFHJLCPRTXVZNYEIWGAKMUSQO"
    @reflector = Reflector.new "YRUHQSLDPXNGOKMIEBFZCWVJAT"
  end

  def process(message)
    forwarded = forward(message)
    reflected = @reflector.translate(forwarded)
    reverse(reflected)
  end

  def forward(input)
    step = input
    step = @right_rotor.forward(step)
    step = @center_rotor.forward(step)
    step = @left_rotor.forward(step)
    step
  end

  def reverse(input)
    step = input
    step = @left_rotor.reverse(step)
    step = @center_rotor.reverse(step)
    step = @right_rotor.reverse(step)
    step
  end
end
