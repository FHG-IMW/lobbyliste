require "lobbyliste/version"
require "lobbyliste/factories"
require "lobbyliste/list"
require "lobbyliste/organisation"
require "lobbyliste/name_and_address"
require "lobbyliste/person"
require "lobbyliste/downloader"
require "lobbyliste/core_ext/string"
require 'json'

module Lobbyliste

  # Download the PDF and parse it
  # @return [Lobbyliste::Liste]
  def self.fetch_and_parse
    downloader = Lobbyliste::Downloader.new
    Lobbyliste::Factories::ListFactory.build(downloader.text_data)
  end
end
