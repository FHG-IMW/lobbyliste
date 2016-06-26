require 'test_helper'

class Lobbyliste::OrganisationTest < Minitest::Test

  def test_name
    name_and_address = stub()
    name_and_address.expects(:name).returns("Organisation Name")
    org = Lobbyliste::Organisation.new(1,name_and_address,nil,nil,nil,nil,nil,nil)

    assert_equal "Organisation Name", org.name
  end

  def test_addresses
    org = Lobbyliste::Organisation.new(1,"Main Address","Other Address","3. Address",nil,nil,nil,nil)
    assert_equal ["Main Address","Other Address","3. Address"], org.addresses
  end

end
