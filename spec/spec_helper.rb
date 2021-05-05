if ENV['COV'] == '1'
  require 'simplecov'
  SimpleCov.start
end

require 'ostruct'
require_relative '../lib/tumblr_client'
require 'dotenv'

Dotenv.load('.env.test')
ENV['RUBYDEV'] = 'test'

def load_credentials
  [:consumer_key,:consumer_secret,:oauth_token,:oauth_token_secret].map do |k|
    [k, ENV[k.to_s.upcase]]
  end.to_h
end