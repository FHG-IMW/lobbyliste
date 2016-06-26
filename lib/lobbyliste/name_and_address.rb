module Lobbyliste
  class NameAndAddress
    attr_reader :name, :address, :postcode, :city, :country, :tel, :fax, :website, :email, :type

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
  end
end
