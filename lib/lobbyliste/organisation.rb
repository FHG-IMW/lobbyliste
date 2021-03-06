module Lobbyliste
  # Class to encapsulate an organisation
  class Organisation

    # @return [Integer] the organisation id of the organisation. This number is not fix and may change with every new document version
    attr_reader :id

    # @return [String] the organisations name
    attr_reader :name

    # @return [Lobbyliste::Address] the primary Address of the organisation
    attr_reader :address

    # @return [Lobbyliste::Address] the address stated under "Weitere Addresse"
    attr_reader :additional_address

    # @return [Lobbyliste::Address] the address stated under "Anschrift am Sitz von BT und BRg"
    attr_reader :address_at_bt_br

    # @return [Array] List of {Lobbyliste::Person} which includes all members stated under "Vorstand und Geschäftsführung" and "Verbandsvertreter/-innen"
    attr_reader :people

    # @return [String] interests as stated under "Interessenbereich"
    attr_reader :interests

    # @return [Integer] number of members as stated under "Mitgleiderzahl"
    attr_reader :members

    # @return [Integer] number of associated organisations as stated under "Anzahl der angeschlossenen Organisationen"
    attr_reader :associated_organisations

    # @return [Array] list of tags
    attr_reader :tags

    # @return [Array] list of abbreviations
    attr_reader :abbreviations

    def initialize(id, name, address, additional_address, address_at_bt_br, people, interests, members, associated_organisations,tags,abbreviations)
      @id = id
      @name = name
      @address = address
      @additional_address = additional_address
      @address_at_bt_br = address_at_bt_br
      @people = people
      @interests = interests
      @members = members
      @associated_organisations = associated_organisations
      @tags = tags
      @abbreviations = abbreviations
    end

    # @return [Array] list of all known addresses
    def addresses
      [address,additional_address,address_at_bt_br].reject(&:nil?)
    end

    def to_json(*a)
      {
          id: id,
          name: name,
          addresses: addresses,
          people: people,
          interests: interests,
          members: members,
          associated_organisations: associated_organisations,
          tags: tags,
          abbreviations: abbreviations
      }.to_json(*a)
    end
  end
end
