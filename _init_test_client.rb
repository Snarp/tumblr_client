require 'dotenv'
require 'active_support/core_ext/hash'
require_relative 'lib/tumblr_client'

@env_fname='.env.test'
Dotenv.load(@env_fname)
ENV['RUBYDEV'] = 'test'

def load_credentials
  [:consumer_key,:consumer_secret,:oauth_token,:oauth_token_secret].map do |k|
    [k, ENV[k.to_s.upcase]]
  end.to_h
end

def client
  @client ||= Tumblr::Client.new(consumer_key: ENV['CONSUMER_KEY'])
end
def auth_client
  @auth_client ||= Tumblr::Client.new(**load_credentials())
end
def init_clients
  @client = Tumblr::Client.new(consumer_key: ENV['CONSUMER_KEY'])
  @auth_client = Tumblr::Client.new(**load_credentials())
end

def assign_vars(input=Dotenv.parse(@env_fname))
  cmd_strs=Array.new
  output=input.map do |var_name, value|
    cmd_strs.push("#{var_name.downcase}=ENV['#{var_name}']")
    eval("@#{var_name.downcase}='#{value}'")
    [var_name.downcase.to_sym, value]
  end.to_h
  File.write('temp/cmd_strs.rb', cmd_strs.join("\n"))
  return output
end
assign_vars()
init_clients()