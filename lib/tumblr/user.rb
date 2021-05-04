module Tumblr
  module User

    def info
      get('v2/user/info')
    end

    def dashboard(options={})
      valid_opts=[:limit,:offset,:type,:since_id,:reblog_info,:notes_info,:npf]
      validate_options(valid_opts, options)
      get('v2/user/dashboard', options)
    end

    def likes(options = {})
      validate_options([:limit, :offset, :before, :after], options)
      get('v2/user/likes', options)
    end

    def following(options = {})
      validate_options([:limit, :offset], options)
      get('v2/user/following', options)
    end

    def follow(url=nil, options={})
      validate_options([:url,:email], options)
      options[:url] ||= url
      post('v2/user/follow', options)
    end

    def unfollow(url)
      post('v2/user/unfollow', :url => url)
    end

    def like(id, reblog_key)
      post('v2/user/like', :id => id, :reblog_key => reblog_key)
    end

    def unlike(id, reblog_key)
      post('v2/user/unlike', :id => id, :reblog_key => reblog_key)
    end

    # TODO: Test me!
    def get_filtered_content
      get('v2/user/filtered_content')
    end

    # TODO: Test me!
    def add_filtered_content(filtered_strings=nil, options={})
      validate_options([:filtered_content], options)
      options[:filtered_content] ||= filtered_strings
      post('v2/user/filtered_content', options)
    end

    # TODO: Test me!
    def delete_filtered_content(filtered_strings, options={})
      validate_options([:filtered_content], options)
      options[:filtered_content] ||= filtered_strings
      delete('v2/user/filtered_content', options)
    end


  end
end
