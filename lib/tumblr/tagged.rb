module Tumblr
  module Tagged

    def tagged(tag, options={})
      validate_options([:before, :limit, :filter], options)
      get("v2/tagged", {tag: tag, api_key: @consumer_key}.merge(options))
    end

  end
end
