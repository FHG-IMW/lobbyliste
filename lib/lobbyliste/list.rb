module Lobbyliste
  class List
    attr_reader :organisations, :tags

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