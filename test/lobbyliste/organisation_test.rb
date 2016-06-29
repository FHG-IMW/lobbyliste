require 'test_helper'

class Lobbyliste::OrganisationTest < Minitest::Test
  def test_addresses
    org = Lobbyliste::Organisation.new(1,"Name","Main Address","Other Address","3. Address",nil,nil,nil,nil,nil,nil)
    assert_equal ["Main Address","Other Address","3. Address"], org.addresses
  end
end
