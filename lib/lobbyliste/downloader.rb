require 'open-uri'
require 'nokogiri'

module Lobbyliste

  # This class finds the lobbyliste pdf on the Bundestag website, downloads it and extracts the pdf content
  class Downloader

    # Creates a new Downloader
    # @param [String] link that will be used to fetch the lobbylist pdf, defaults to nil
    def initialize(pdf_link=nil)
      @pdf_link = pdf_link
    end

    # @return [String] raw content of pdf file
    def pdf_data
      retrieve_pdf unless @pdf_data
      @pdf_data
    end


    # @return [String] extracted content of pdf file
    def text_data
      extract_pdf unless @text_data
      @text_data
    end

    # @return [String] extracted content of pdf file in html format
    def html_data
      extract_pdf unless @html_data
      @html_data
    end

    # @return [String] link to Lobbyliste pdf
    def pdf_link
      fetch_pdf_link unless @pdf_link
      @pdf_link
    end

    private

    # Since this link changes with every new version we download the Lobbyliste website and try to extract the link
    # @return [String] the link to the Lobbyliste pdf
    def fetch_pdf_link
      website = Nokogiri::HTML(open("https://www.bundestag.de/dokumente/lobbyliste"))
      link = website.css("a[title^='Aktuelle Fassung']").first

      raise "Could no find PDF link on the website!" unless link
      @pdf_link = "https://bundestag.de#{link['href']}"
    end


    def retrieve_pdf
      @pdf_data = open(pdf_link) {|f| f.read}
    end


    def extract_pdf
      pdf_file = Tempfile.new(["lobbyliste",".pdf"])
      pdf_file.write(pdf_data)
      pdf_file.rewind

      @text_data = run_extraction(pdf_file)
      @html_data = run_extraction(pdf_file,true)
    ensure
      pdf_file.close
      pdf_file.unlink
    end

    def run_extraction(pdf_file,html=false)
      tmp_file = Tempfile.new(["lobbyliste"])
      status = system("/usr/bin/java -jar #{jar_path} ExtractText #{pdf_file.path} #{html ? "-html":""} #{tmp_file.path} > /dev/null 2>&1")
      raise "PDF extraction failed" unless status
      return tmp_file.read
    ensure
      tmp_file.close
      tmp_file.unlink
    end

    def jar_path
      File.join(File.dirname(File.expand_path(__FILE__)), '../../ext/pdfbox.jar')
    end
  end
end
