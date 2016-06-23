require 'open-uri'
require 'nokogiri'

module Lobbyliste
  class Downloader

    attr_accessor :pdf_data, :text_data

    def initialize
      retrieve_pdf
    end

    def pdf_link
      website = Nokogiri::HTML(open("https://www.bundestag.de/dokumente/lobbyliste"))
      link = website.css(".inhalt a[title^='Aktuelle Fassung']").first

      raise "Could no find PDF link on the website!" unless link
      "https://bundestag.de#{link['href']}"
    end

    def retrieve_pdf
      @pdf_data = open(pdf_link) {|f| f.read}
      extract_pdf
    end


    def extract_pdf
      begin
        pdf_file = Tempfile.new(["lobbyliste",".pdf"])
        pdf_file.write(@pdf_data)
        pdf_file.rewind

        text_file = Tempfile.new(["lobbyliste",".txt"])
        status = system("/usr/bin/java -jar #{jar_path} ExtractText #{pdf_file.path} #{text_file.path} > /dev/null 2>&1")
        raise "PDF extraction failed" unless status

        @text_data = text_file.read
      ensure
        pdf_file.close
        pdf_file.unlink
      end
    end


    private

    def jar_path
      File.join(File.dirname(File.expand_path(__FILE__)), '../../ext/pdfbox.jar')
    end
  end
end