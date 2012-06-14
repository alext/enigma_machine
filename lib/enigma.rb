class Enigma
  ALPHABET = ('A'..'Z').to_a

  def initialize(left_rotor, center_rotor, right_rotor)
    @translator = { "E" => "Q", "Q" => "E" }
    #@rota1 = "EKMFLGDQVZNTOWYHXUSPAIRBCJ"
    #@rota2 = "AJDKSIRUXBLHWTMCQGZNPYFVOE"
    #@rota3 = "BDFHJLCPRTXVZNYEIWGAKMUSQO"
    #@reflector = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
  end

  def process(message)
    @translator[message]
  end
end
