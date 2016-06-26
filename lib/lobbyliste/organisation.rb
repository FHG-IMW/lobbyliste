module Lobbyliste
  class Organisation
    attr_reader :id, :name_and_address, :additional_address, :address_at_bt_br, :people, :interests, :members, :associated_organisations
    attr_accessor :tags

    def initialize(id, name_and_address, additional_address, address_at_bt_br, people, interests, members, associated_organisations)
      @id = id
      @name_and_address = name_and_address
      @additional_address = additional_address
      @address_at_bt_br = address_at_bt_br
      @people = people
      @interests = interests
      @members = members
      @associated_organisations = associated_organisations
      @tags = []
    end

    def name
      name_and_address.name
    end

    def addresses
      [name_and_address,additional_address,address_at_bt_br].reject(&:nil?)
    end
  end
end
