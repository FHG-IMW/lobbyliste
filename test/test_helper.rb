$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lobbyliste'

require 'minitest/autorun'
require 'mocha/mini_test'
require 'webmock/minitest'
require 'vcr'


VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.hook_into :webmock
end
