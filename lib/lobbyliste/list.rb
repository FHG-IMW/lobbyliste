module Lobbyliste

  # This class represents an instance of the parsed lobbylist.
  class List

    # @return [Array] list of organisations
    attr_reader :organisations

    # @return [Hash] keys are the tags, values are Arrays of organisation ids
    attr_reader :tags

    # @return [Hash] keys are the abbreviations, values are Arrays of organisation ids
    attr_reader :abbreviations

    # @return [Date] the date when the document was last updated
    attr_reader :last_update

    def initialize(organisations, tags, abbreviations, last_update)
      @organisations = organisations
      @tags=tags
      @abbreviations = abbreviations
      @last_update = last_update
    end

    def to_json(*a)
      {
          organisations: organisations,
          tags: tags,
          abbreviations: abbreviations,
          last_update: last_update
      }.to_json(*a)
    end
  end
end