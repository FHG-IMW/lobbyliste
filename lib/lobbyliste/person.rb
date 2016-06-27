module Lobbyliste
  class Person
    attr_reader :name, :titles

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