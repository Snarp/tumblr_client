module Tumblr
  module Blog

    # Gets the info about the blog
    def blog_info(blog_name)
      get(blog_path(blog_name, 'info'), :api_key => @consumer_key)
    end

    # Gets the avatar URL of specified size
    def avatar(blog_name, size = nil)
      url = blog_path(blog_name, 'avatar')
      url = "#{url}/#{size}" if size
      get_redirect_url(url)
    end

    # Gets the list of followers for the blog
    def followers(blog_name, options = {})
      validate_options([:limit, :offset], options)
      get(blog_path(blog_name, 'followers'), options)
    end
    alias_method :blog_followers, :followers

    def blog_following(blog_name, options={})
      validate_options([:limit, :offset], options)
      get(blog_path(blog_name, 'following'), options)
    end

    def followed_by(blog_name, query=nil, **options)
      validate_options([:query], options)
      options[:query] ||= query
      get(blog_path(blog_name, 'followed_by'), options)
    end
    alias_method :blog_followed_by, :followed_by

    # Gets the list of likes for the blog
    def blog_likes(blog_name, options = {})
      validate_options([:limit, :offset, :before, :after], options)
      url = blog_path(blog_name, 'likes')
      get(url, {api_key: @consumer_key}.merge(options))
    end

    def posts(blog_name, options = {})
      url = blog_path(blog_name, 'posts')
      if type = options.delete(:type)
        url = "#{url}/#{type}"
      end
      get(url, {api_key: @consumer_key}.merge(options))
    end

    def get_post(blog_name, post_id, options={})
      validate_options([:post_format], options)
      get(blog_path(blog_name, "posts/#{post_id}"), options)
    end

    def queue(blog_name, options = {})
      validate_options([:limit,:offset,:filter], options)
      get(blog_path(blog_name, 'posts/queue'), options)
    end

    # TODO: Test me!
    def reorder_queue(blog_name, options={})
      validate_options([:post_id,:insert_after], options)
      post(blog_path(blog_name, 'posts/queue/reorder'), options)
    end

    # TODO: Test me!
    def shuffle_queue(blog_name)
      post(blog_path(blog_name, 'posts/queue/shuffle'))
    end

    def draft(blog_name, options = {})
      validate_options([:limit, :before_id], options)
      get(blog_path(blog_name, 'posts/draft'), options)
    end
    alias_method :drafts, :draft

    def submissions(blog_name, options = {})
      validate_options([:limit, :offset], options)
      get(blog_path(blog_name, 'posts/submission'), options)
    end
    alias_method :submission, :submissions

    # REVIEW: :types args do not appear to be working as of 2021-05-04
    def notifications(blog_name, options={})
      validate_options([:before,:types], options)
      get(blog_path(blog_name, 'notifications'), options)
    end

    def blocks(blog_name, options={})
      validate_options([:limit,:offset], options)
      get(blog_path(blog_name, 'blocks'), options)
    end
    alias_method :blocked, :blocks

    def block(blocker_blog_name, blockee=nil, options={})
      validate_options([:blocked_tumblelog,:post_id], options)
      options[:blocked_tumblelog] ||= blockee
      post(blog_path(blocker_blog_name, 'blocks'), options)
    end

    def unblock(blocker_blog_name, blockee=nil, options={})
      validate_options([:blocked_tumblelog,:anonymous_only], options)
      options[:blocked_tumblelog] ||= blockee
      puts "#{{blocker_blog_name: blocker_blog_name, options: options}}"
      delete(blog_path(blocker_blog_name, 'blocks'), options)
    end

    def notes(blog_name, post_id=nil, options={})
      validate_options([:id,:before_timestamp,:mode], options)
      options[:id] ||= post_id
      puts "#{{path: blog_path(blog_name, 'notes'), options: options}}"
      get(blog_path(blog_name, 'notes'), options)
    end

  end
end
