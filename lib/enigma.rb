class Enigma
  ALPHABET = ('A'..'Z').to_a

  def initialize(left_rotor, center_rotor, right_rotor)
    @translator = { "E" => "Q", "Q" => "E" }
    @reverse_translation  = { "N" => "C", 'W' => 'E' }
    @left_rotor = "EKMFLGDQVZNTOWYHXUSPAIRBCJ"
    @left_offset = ALPHABET.index(left_rotor[1])
    @center_rotor = "AJDKSIRUXBLHWTMCQGZNPYFVOE"
    @center_offset = ALPHABET.index(center_rotor[1])
    @right_rotor = "BDFHJLCPRTXVZNYEIWGAKMUSQO"
    @right_offset = ALPHABET.index(right_rotor[1])
    @reflector = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
  end

  def process(message)
    forwarded = forward(message)
    reflected = reflect(forwarded)
    reverse(reflected)
  end

  def reflect(input)
    index = @reflector.index( input )
    ALPHABET[index]
  end

  def forward(input)
    index = ALPHABET.index( input )
    step = @right_rotor[index]
    index = ALPHABET.index( step )
    step = @center_rotor[index]
    index = ALPHABET.index( step )
    step = @left_rotor[index]
    step
  end

  def reverse(input)
    index = @left_rotor.index(input)
    step = ALPHABET[index]
    index = @center_rotor.index(step)
    step = ALPHABET[index]
    index = @right_rotor.index(step)
    step = ALPHABET[index]
    step
  end
end
