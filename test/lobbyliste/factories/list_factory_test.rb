require 'test_helper'

class Lobbyliste::Factories::ListFactoryTest < Minitest::Test
  def setup
    @data = File.read(File.join(File.dirname(File.expand_path(__FILE__)), '../../test_data/lobbyliste_text.txt'))
    @list = Lobbyliste::Factories::ListFactory.new(@data)
  end


  def test_organisation_extraction
    organisations = @list.organisations
    assert_equal 4, organisations.count
    assert organisations.all? {|org| org.is_a?(Lobbyliste::Organisation)}
    assert_equal [1,2,3,4], organisations.map(&:id)
  end

  def test_organisation_tagging
    organisations = @list.organisations
    assert_equal ["Abbruch"], organisations.first.tags
    assert_equal ["Bau"], organisations.last.tags
    refute organisations[2].tags.any?
  end

  def test_tag_extraction
    assert_equal 2, @list.tags.keys.count
    refute @list.tags.keys.include?("Dialog")
    assert_equal [1,2], @list.tags["Abbruch"]
  end

  def test_build
    list = Lobbyliste::Factories::ListFactory.build(@data)
    assert list.is_a?(Lobbyliste::List)
    assert_equal 4, list.organisations.count
    assert_equal 2, list.tags.count
  end
end
