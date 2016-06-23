module Lobbyliste
  class List
    attr_reader :organisations, :tags

    def initialize(organisations, tags)
      @organisations = organisations
      @tags=tags
    end
  end
end