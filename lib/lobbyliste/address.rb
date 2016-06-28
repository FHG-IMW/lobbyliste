module Lobbyliste

  # This class represents addresses found in the lobbylist.
  class Address
    # @return [String] organisation name (the bold part)
    attr_reader :name

    # @return [String] Everything that is not part of the name or any other field
    attr_reader :address

    # @return [String] Postcode
    attr_reader :postcode

    # @return [String] City
    attr_reader :city

    # @return [String] the country, default: "Germany"
    attr_reader :country

    # @return [String] the telephone number if given (german numbers are automatically prefixed with +49)
    attr_reader :tel

    # @return [String] the fax number if given (german numbers are automatically prefixed with +49)
    attr_reader :fax

    # @return [String] website url
    attr_reader :website

    # @return [String] contact email address
    attr_reader :email

    # @return [Symbol] address type, :primary for 1. address, :secondary for all others
    attr_reader :type

    def initialize(name, address, postcode, city, country, tel, fax, website, email, type)
      @name = name
      @address = address
      @postcode = postcode
      @city = city
      @country = country
      @tel = tel
      @fax = fax
      @website = website
      @email = email
      @type=type
    end

    # @return String pretty formated address of all existing address fields
    def full_address
      full_address = [
        @name,
        @address,
        [@postcode,@city].reject(&:nil?).join(" "),
        @country,
      ]

      full_address << "Tel: #{@tel}" if @tel
      full_address << "Fax: #{@fax}" if @fax
      full_address << "Email: #{@email}" if @email
      full_address << @website if @website
      full_address.reject(&:nil?).join("\n")
    end

    def to_json(*a)
      {
          name: name,
          address: address,
          postcode: postcode,
          city: city,
          country: country,
          tel: tel,
          fax: fax,
          email: email,
          website: website,
          type: type.to_s
      }.to_json(*a)
    end
  end
end
