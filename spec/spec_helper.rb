if ENV['COV'] == '1'
  require 'simplecov'
  SimpleCov.start
end

require 'ostruct'
require_relative '../lib/tumblr_client'

def load_test_env
  JSON::parse(File.read('../.env.test.json'), symbolize_names: true)
end