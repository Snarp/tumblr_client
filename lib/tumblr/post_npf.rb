require 'mime/types'

module Tumblr
  module PostNpf

    NPF_STANDARD_POST_OPTIONS = [:content, :layout, :state, :publish_on, :date, :tags, :source_url, :send_to_twitter, :send_to_facebook, :is_private, :slug]
    NPF_REBLOG_POST_OPTIONS = [:parent_tumblelog_uuid, :parent_post_id, :reblog_key, :hide_trail, :exclude_trail_items]
    NPF_POST_OPTIONS = NPF_STANDARD_POST_OPTIONS + NPF_REBLOG_POST_OPTIONS

    # TODO: Test me!
    def create_npf_post(blog_name, options={})
      validate_options(NPF_POST_OPTIONS, options)
      post(blog_path(blog_name, "posts"), options)
    end

    # TODO: Test me!
    def edit_npf_post(blog_name, post_id, options={})
      post_id ||= options.delete(:id)
      validate_options(NPF_POST_OPTIONS, options)
      put(blog_path(blog_name, "posts/#{post_id}"), options)
    end

  end
end