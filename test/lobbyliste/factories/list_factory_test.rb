require 'test_helper'

class Lobbyliste::Factories::ListFactoryTest < Minitest::Test
  def setup
    @text_data = File.read(File.join(File.dirname(File.expand_path(__FILE__)), '../../test_data/lobbyliste_text.txt'))
    @html_data = File.read(File.join(File.dirname(File.expand_path(__FILE__)), '../../test_data/lobbyliste_html.html'))
    @list = Lobbyliste::Factories::ListFactory.new(@text_data,@html_data)
  end


  def test_ignored_lines
    lines_to_ignore = [
      "– 4 –",
      "Aktuelle Fassung der öffentlichen Liste über die Registrierung von Verbänden und deren Vertretern (Stand: 10.06.2016)",
      "Die Zahlen verweisen auf die fortlaufenden Nummern im Hauptteil",
      "\n"
    ]

    lines_to_ignore.each do |line|
      assert @list.send(:ignored_line?,line), "'#{line}' should be ignored"
    end
  end

  def test_organisation_data_does_not_include_ignored_lines
    refute @list.send(:organisations_data).flatten.any? {|line| @list.send(:ignored_line?,line)}
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

  def test_name_extraction
    assert_equal 4, @list.names.keys.count
    assert_equal %w{1 2 3 4}, @list.names.keys
    assert_equal "1219. Deutsche Stiftung für interreligiösen und interkulturellen Dialog e. V.", @list.names["1"]
  end

  def test_build
    list = Lobbyliste::Factories::ListFactory.build(@text_data,@html_data)
    assert list.is_a?(Lobbyliste::List)
    assert_equal 4, list.organisations.count
    assert_equal 2, list.tags.count
  end
end
