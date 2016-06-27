module Lobbyliste
  # Class to encapsulate a person.
  class Person

    # @return [String] the persons name (hopefully) stripped of all titles
    attr_reader :name

    # @return [Array] list of all titles (job, academic, positions)
    attr_reader :titles

    def initialize(name, titles)
      @name = name
      @titles = titles
    end

    def ==(other)
      name==other.name && titles==other.titles
    end

    def to_json(*a)
      {
          name: name,
          titles: titles
      }.to_json(*a)
    end
  end
end