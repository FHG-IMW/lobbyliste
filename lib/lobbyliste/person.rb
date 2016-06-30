module Lobbyliste
  # Class to encapsulate a person.
  class Person

    # @return [String] the persons name (hopefully) stripped of all titles
    attr_reader :name

    # @return [Array] list of all titles (job, academic, positions)
    attr_reader :titles

    # @return [String] the original name with titles as stated in the document
    attr_reader :original_name

    def initialize(name, titles, original_name)
      @name = name
      @titles = titles
      @original_name = original_name
    end

    def ==(other)
      original_name==other.original_name
    end

    def to_json(*a)
      {
          name: name,
          titles: titles
      }.to_json(*a)
    end
  end
end