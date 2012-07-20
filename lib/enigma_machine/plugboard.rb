class EnigmaMachine
  class Plugboard
    def initialize(mapping_pairs, decorated)
      build_mapping(mapping_pairs)
      @decorated = decorated
    end

    def translate(letter)
      step = substitute(letter)
      step = @decorated.translate(step)
      substitute(step)
    end

    def substitute(letter)
      @mapping[letter] || letter
    end

    private

    def build_mapping(letter_pairs)
      @mapping = {}
      letter_pairs.each do |pair|
        raise ConfigurationError unless pair =~ /\A[A-Z]{2}\z/
        a, b = pair.split('')
        raise ConfigurationError if @mapping[a] or @mapping[b]
        @mapping[a] = b
        @mapping[b] = a
      end
    end
  end
end
