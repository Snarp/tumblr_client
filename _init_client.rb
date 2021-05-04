require 'dotenv/load'
require 'active_support/core_ext/hash'
require_relative 'lib/tumblr_client'

def init_client
  @client = Tumblr::Client.new(consumer_key: ENV['CONSUMER_KEY'], 
    consumer_secret: ENV['CONSUMER_SECRET'], 
    oauth_token: ENV['OAUTH_TOKEN'],
    oauth_token_secret: ENV['OAUTH_TOKEN_SECRET'], 
    symbolize_keys: true)
end

init_client