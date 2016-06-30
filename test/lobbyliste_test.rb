require 'test_helper'

class LobbylisteTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Lobbyliste::VERSION
  end

  def test_fetch_and_parse
    Lobbyliste::Downloader.any_instance.expects(:text_data).returns("TEXT_DATA")
    Lobbyliste::Downloader.any_instance.expects(:html_data).returns("HTML_DATA")

    Lobbyliste::Factories::ListFactory.expects(:build).with("TEXT_DATA","HTML_DATA").returns("LISTE")

    assert_equal "LISTE", Lobbyliste.fetch_and_parse
  end
end
