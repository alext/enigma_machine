class EnigmaMachine
  class Plugboard
    # Construct a new plugboard
    #
    # Example:
    #
    #   Plugboard.new(%w(AB CD EF GH), @rotor)
    #
    # @param mapping_pairs [Array<String>] A list of letter pairs to be connected
    # @param rotor [Rotor] the rightmost rotor that will be called next in the processing chain
    def initialize(mapping_pairs, rotor)
      build_mapping(mapping_pairs)
      @decorated = rotor
    end

    # Translate a letter
    #
    # This performs a substitution, calls the rotor to do the rest of the translation, and then
    # substitutes the result on the way back out.
    #
    # @param letter [String] the letter to be translated
    # @return [String] the translated letter
    def translate(letter)
      step = substitute(letter)
      step = @decorated.translate(step)
      substitute(step)
    end

    # Substitutes a letter according the configured plug pairs
    # @param letter [String] the letter to be substituted
    # @return [String] the substituted letter
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
