class EnigmaMachine
  class Rotor
    def initialize(rotor_spec, ring_setting, decorated)
      mapping, step_points = rotor_spec.split('_', 2)
      @mapping = mapping.each_char.map {|c| ALPHABET.index(c) }
      @ring_offset = ring_setting - 1
      @decorated = decorated
      self.position = 'A'
    end

    def position=(letter)
      @position = ALPHABET.index(letter)
    end
    def position
      ALPHABET[@position]
    end

    def advance_position
      @position = (@position + 1).modulo(26)
    end

    def forward(letter)
      index = add_offset ALPHABET.index(letter)
      new_index = sub_offset @mapping[index]
      ALPHABET[new_index]
    end

    def reverse(letter)
      index = add_offset ALPHABET.index(letter)
      new_index = sub_offset @mapping.index(index)
      ALPHABET[new_index]
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

    def add_offset(number)
      (number + rotor_offset).modulo(26)
    end
    def sub_offset(number)
      (number - rotor_offset).modulo(26)
    end
  end
end
