require 'test_helper'

class Lobbyliste::OrganisationTest < Minitest::Test

  def test_pdf_link
    VCR.use_cassette("bundestag_website") do
      downloader = Lobbyliste::Downloader.new
      assert_equal "https://bundestag.de/blob/189476/b5c8f2195537f84bdb1fe398ff721d9d/lobbylisteaktuell-data.pdf", downloader.pdf_link
    end
  end

  def test_pdf_link_with_given_link
    link = "http://example.com/link"
    downloader = Lobbyliste::Downloader.new(link)

    assert_equal link, downloader.pdf_link
  end

  def test_pdf_download
    pdf_address = "http://example.com/lobbyliste.pdf"

    Lobbyliste::Downloader.any_instance.expects(:pdf_link).returns(pdf_address)
    stub_request(:get, pdf_address).
      to_return(status: 200, body: "Lobbyliste", headers: { 'Content-Length' => 10})

    VCR.turned_off do
      downloader = Lobbyliste::Downloader.new
      assert_equal 10, downloader.pdf_data.length
      assert_equal "Lobbyliste", downloader.pdf_data
    end
  end

end
