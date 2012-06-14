class Enigma
  ALPHABET = ('A'..'Z').to_a

  def initialize(left_rotor, center_rotor, right_rotor)
    @translator = { "E" => "Q", "Q" => "E" }
    @forward_translation = { "E" => "S", 'Q' => 'F'}
    @reverse_translation  = { "F" => "Q", 'S' => 'E' }
    #@rota1 = "EKMFLGDQVZNTOWYHXUSPAIRBCJ"
    #@rota2 = "AJDKSIRUXBLHWTMCQGZNPYFVOE"
    #@rota3 = "BDFHJLCPRTXVZNYEIWGAKMUSQO"
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
    @forward_translation[input]
  end

  def reverse(input)
    @reverse_translation[input]
  end
end
