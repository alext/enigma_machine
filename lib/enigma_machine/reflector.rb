class EnigmaMachine
  class Reflector < Plugboard
    def initialize(mapping)
      raise ConfigurationError unless mapping.length == 13
      build_mapping(mapping)
    end

    alias :translate :substitute
  end
end
