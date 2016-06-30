require "lobbyliste/version"
require "lobbyliste/factories"
require "lobbyliste/list"
require "lobbyliste/organisation"
require "lobbyliste/address"
require "lobbyliste/person"
require "lobbyliste/downloader"
require "lobbyliste/core_ext/string"
require 'json'

module Lobbyliste

  # Download the PDF and parse it
  # @param [String] link to Lobbyliste pdf, if left out pdf link is retrieved automatically from Bundestag website
  # @return [Lobbyliste::Liste]
  def self.fetch_and_parse(pdf_link=nil)
    downloader = Lobbyliste::Downloader.new(pdf_link)
    Lobbyliste::Factories::ListFactory.build(downloader.text_data,downloader.html_data)
  end
end
