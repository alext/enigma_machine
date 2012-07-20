class EnigmaMachine
  class Reflector < Plugboard
    STANDARD_MAPPINGS = {
      :A => %w(AE BJ CM DZ FL GY HX IV KW NR OQ PU ST),
      :B => %w(AY BR CU DH EQ FS GL IP JX KN MO TZ VW),
      :C => %w(AF BV CP DJ EI GO HY KR LZ MX NW TQ SU),
      :Bthin => %w(AE BN CK DQ FU GY HW IJ LO MP RX SZ TV),
      :Cthin => %w(AR BD CO EJ FN GT HK IV LM PW QZ SX UY),
    }

    def initialize(mapping)
      if mapping.is_a?(Symbol)
        raise ConfigurationError unless STANDARD_MAPPINGS.has_key?(mapping)
        mapping = STANDARD_MAPPINGS[mapping]
      end
      raise ConfigurationError unless mapping.length == 13
      build_mapping(mapping)
    end

    alias :translate :substitute
  end
end
