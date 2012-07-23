class EnigmaMachine
  class Reflector < Plugboard
    STANDARD_MAPPINGS = {
      :A => %w(AE BJ CM DZ FL GY HX IV KW NR OQ PU ST),
      :B => %w(AY BR CU DH EQ FS GL IP JX KN MO TZ VW),
      :C => %w(AF BV CP DJ EI GO HY KR LZ MX NW TQ SU),
      :Bthin => %w(AE BN CK DQ FU GY HW IJ LO MP RX SZ TV),
      :Cthin => %w(AR BD CO EJ FN GT HK IV LM PW QZ SX UY),
    }

    # Construct a new reflector
    #
    # Example:
    #
    #   Reflector.new(%w(AY BR CU DH EQ FS GL IP JX KN MO TZ VW))
    #
    # @param mapping [Array<String>] A list of 13 letter pairs to be swapped by the reflector
    # @raise [ConfigurationError] if an invalid mapping is passed in (not 13 pairs of letters, or a letter appearing more than once)
    def initialize(mapping)
      if mapping.is_a?(Symbol)
        raise ConfigurationError unless STANDARD_MAPPINGS.has_key?(mapping)
        mapping = STANDARD_MAPPINGS[mapping]
      end
      raise ConfigurationError unless mapping.length == 13
      build_mapping(mapping)
    end

    # @!method translate(letter)
    #   simply perform a substitution
    #
    #   @param letter [String] the letter to be substituted
    #   @return [String] the substituted letter
    alias :translate :substitute
  end
end
