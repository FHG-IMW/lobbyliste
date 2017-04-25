require 'test_helper'

class Lobbyliste::Factories::AddressFactoryTest < Minitest::Test
  def setup
    @data = [
        "1219. Deutsche Stiftung für interreligiösen und interkulturellen",
        "Dialog e. V.",
        "Hinter der katholischen Kirche 3",
        "10117 Berlin",
        "Tel.: (030) 51057773 Fax: (030) 51057785",
        "E-Mail: schimmel@1219.eu",
        "Internet: http://www.1219.eu",
    ]
    @name = "1219. Deutsche Stiftung für interreligiösen und interkulturellen Dialog e. V."
    @name_and_address = Lobbyliste::Factories::AddressFactory.new(@name, @data)
  end


  def test_name_extraction
    assert_equal "1219. Deutsche Stiftung für interreligiösen und interkulturellen Dialog e. V.", @name_and_address.name
  end

  def test_address_extraction
    assert_equal "Hinter der katholischen Kirche 3", @name_and_address.address
  end

  def test_postcode_extraction
    assert_equal "10117", @name_and_address.postcode
  end


  def test_city_extraction
    assert_equal "Berlin", @name_and_address.city
  end


  def test_tel_fax_extraction
    assert_equal "+4930 51057773", @name_and_address.tel
    assert_equal "+4930 51057785", @name_and_address.fax
  end


  def test_email_extraction
    assert_equal "schimmel@1219.eu", @name_and_address.email
  end


  def test_website_extraction
    assert_equal "http://www.1219.eu", @name_and_address.website
  end

  def test_country_default
    assert_equal "Deutschland", @name_and_address.country
  end

  def test_country_extraction
    data = [
        "1219. Deutsche Stiftung für interreligiösen und interkulturellen",
        "Dialog e. V.",
        "Hinter der katholischen Kirche 3",
        "10117 Berlin",
        "Germany",
        "Tel.: (030) 51057773 Fax: (030) 51057785",
        "E-Mail: schimmel@1219.eu",
        "Internet: http://www.1219.eu",
    ]
    name_and_address = Lobbyliste::Factories::AddressFactory.new(@name,data)

    assert_equal "Germany", name_and_address.country
  end

  def test_recognize_uk_addresses
    data = [
      "Crescent House",
      "5 The Cresent",
      "Surbiton, Surrey",
      "KT6 4BN",
      "Vereinigtes Königreich",
    ]
    name_and_address = Lobbyliste::Factories::AddressFactory.new(@name, data, :secondary)

    assert_equal "Crescent House, 5 The Cresent, Surbiton, Surrey" ,name_and_address.address
    assert_equal "KT6 4BN" ,name_and_address.postcode
    assert_nil name_and_address.city
    assert_equal "Vereinigtes Königreich" ,name_and_address.country
  end

end
