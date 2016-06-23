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
  end
end