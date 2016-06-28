require 'test_helper'

class Lobbyliste::NameAndAddressTest < Minitest::Test

  def test_full_address
    name_and_address = Lobbyliste::Address.new(
      "Test Name",
      "Test Address",
      "012345",
      "City",
      "Germany",
      "012345678",
      "012345678",
      "email@example.com",
      "http://example.com",
      :primary
    )

    assert name_and_address.full_address.include?("012345 City")
    assert name_and_address.full_address.include?("Tel: 012345678")
    assert_equal 8, name_and_address.full_address.each_line.count
  end
end
