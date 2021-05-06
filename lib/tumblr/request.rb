require 'json'
# TODO: Remove YAML logging stuff once testing is done!
require 'yaml'

module Tumblr
  module Request

    # Perform a get request and return the raw response
    def get_response(path, params = {})
      connection.get do |req|
        req.url path
        req.params = params
      end
    end

    # get a redirect url
    def get_redirect_url(path, params = {})
      response = get_response path, params
      if (300..308).include?(response.status)
        response.headers['Location'] || response.headers[:Location]
      else
        response.body['meta'] || response.body[:meta]
      end
    end

    # Performs a get request
    def get(path, params={})
      respond get_response(path, params)
    end

    # Performs post request
    def post(path, params={})
      if Array === params[:tags]
        params[:tags] = params[:tags].join(',')
      end
      response = connection.post do |req|
        req.url path
        req.body = params unless params.empty?
      end
      #Check for errors and encapsulate
      respond(response)
    end

    # TODO: Test me!
    def put(path, params={})
      response = connection.put do |req|
        req.url path
        req.body = params unless params.empty?
      end
      respond(response)
    end

    def delete(path, params={})
      response = connection.delete do |req|
        req.url path
        req.body = params unless params.empty?
      end
      respond(response)
    end

    # TODO: Remove once testing is done!
    attr_accessor :response

    def respond(response)
      # TODO: Remove YAML logging stuff once testing is done!
      if ENV['RUBYDEV'] && response
        @response = response
        File.write("temp/responses/STAT_#{response.status}_#{Time.now.to_f}.yml", response.to_yaml)
      end

      output = if [201, 200].include?(response.status)
        response.body['response'] || response.body[:response]
      else
        # surface the meta alongside response
        res = response.body['meta'] || response.body[:meta] || {}
        inner_res = response.body['response'] || response.body[:response]
        res.merge! inner_res if inner_res.is_a?(Hash)
        res
      end
    end

  end
end
