module Lobbyliste

  # This class represents an instance of the parsed lobbylist.
  class List

    # @return [Array] list of organisations
    attr_reader :organisations

    # @return [Hash] keys are the tags, values are Arrays of organisation ids
    attr_reader :tags

    def initialize(organisations, tags)
      @organisations = organisations
      @tags=tags
    end

    def to_json(*a)
      {
          organisations: organisations,
          tags: tags
      }.to_json(*a)
    end
  end
end