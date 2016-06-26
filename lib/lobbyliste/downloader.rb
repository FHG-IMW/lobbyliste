require 'open-uri'
require 'nokogiri'

module Lobbyliste
  class Downloader


    def pdf_data
      retrieve_pdf unless @pdf_data
      @pdf_data
    end

    def text_data
      extract_pdf unless @text_data
      @text_data
    end

    private

    def pdf_link
      website = Nokogiri::HTML(open("https://www.bundestag.de/dokumente/lobbyliste"))
      link = website.css(".inhalt a[title^='Aktuelle Fassung']").first

      raise "Could no find PDF link on the website!" unless link
      "https://bundestag.de#{link['href']}"
    end

    def retrieve_pdf
      @pdf_data = open(pdf_link) {|f| f.read}
    end


    def extract_pdf
      begin
        pdf_file = Tempfile.new(["lobbyliste",".pdf"])
        pdf_file.write(pdf_data)
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
