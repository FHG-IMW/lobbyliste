module Lobbyliste
  class Organisation
    attr_reader :id, :name_and_address, :additional_address, :people, :interests, :members, :associated_organisations
    attr_accessor :tags

    def initialize(id, name_and_address, additional_address, people, interests, members, associated_organisations)
      @id = id
      @name_and_address = name_and_address
      @additional_address = additional_address
      @people = people
      @interests = interests
      @members = members
      @associated_organisations = associated_organisations
      @tags = nil
    end

    def name
      name_and_address.name
    end
  end
end