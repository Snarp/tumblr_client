require 'spec_helper'

describe Tumblr::Blog do
  # The below values should be defined in `.env.spec` in the root directory.
  # A template with some suggested values is defined in `_env.spec`.
  let(:consumer_key)               { ENV['CONSUMER_KEY'] }

  let(:blog_username)              { ENV['BLOG_USERNAME'] }
  let(:blog_name)                  { ENV['BLOG_NAME'] }
  let(:blog_uuid)                  { ENV['BLOG_UUID'] }
  let(:blog_post_id)               { ENV['BLOG_POST_ID'] }

  let(:own_blog_username)          { ENV['OWN_BLOG_USERNAME'] }
  let(:blog_following_own_blog)    { ENV['BLOG_FOLLOWING_OWN_BLOG'] }
  let(:blog_with_public_following) { ENV['BLOG_WITH_PUBLIC_FOLLOWING'] }
  let(:blog_with_public_likes)     { ENV['BLOG_WITH_PUBLIC_LIKES'] }

  let(:sleep_interval)             { ENV['SLEEP_INTERVAL'].to_f }

  let(:client)      { Tumblr::Client.new(consumer_key: consumer_key) }
  let(:auth_client) { Tumblr::Client.new(**load_credentials())}


  before(:each) do
    sleep(ENV['SLEEP_INTERVAL'].to_f)
  end

  # describe :blog_info do
  #   context 'with valid input' do
  #     it 'should make the proper request with a blog url' do
  #       response = client.get("v2/blog/#{blog_name}/info", api_key: consumer_key)
  #       expect(response).to be_instance_of Hash
  #       expect(response['blog']).to be_instance_of Hash
  #       sleep(sleep_interval)
  #       r = client.blog_info blog_name
  #       expect(r).to eq(response)
  #     end

  #     it 'should make the proper request with a short blog name' do
  #       response = client.get("v2/blog/#{blog_username}.tumblr.com/info", api_key: consumer_key)
  #       expect(response).to be_instance_of Hash
  #       expect(response['blog']).to be_instance_of Hash
  #       sleep(sleep_interval)
  #       r = client.blog_info blog_username
  #       expect(r).to eq(response)
  #     end

  #     it 'should make the proper request with a blog UUID' do
  #       response = client.get("v2/blog/#{blog_uuid}/info", api_key: consumer_key)
  #       expect(response).to be_instance_of Hash
  #       expect(response['blog']).to be_instance_of Hash
  #       sleep(sleep_interval)
  #       r = client.blog_info blog_uuid
  #       expect(r).to eq(response)
  #     end
  #   end # context 'with valid input'
  # end # describe :blog_info

  # describe :avatar do
  #   context 'when supplying a size' do
  #     it 'should construct the request properly' do
  #       url = client.get_redirect_url("v2/blog/#{blog_name}/avatar/128")
  #       expect(url).to be_instance_of String
  #       expect(url.start_with?('http')).to be true
  #       sleep(sleep_interval)
  #       r = client.avatar blog_name, 128
  #       expect(r).to eq(url)
  #     end
  #   end

  #   context 'when no size is specified' do
  #     it 'should construct the request properly' do
  #       url = client.get_redirect_url("v2/blog/#{blog_name}/avatar")
  #       expect(url).to be_instance_of String
  #       expect(url.start_with?('http')).to be true
  #       sleep(sleep_interval)
  #       r = client.avatar blog_name
  #       expect(r).to eq(url)
  #     end
  #   end
  # end # describe :avatar

  # describe :followers do
  #   context 'with invalid parameters' do
  #     it 'should raise an error' do
  #       expect(lambda {
  #         auth_client.followers blog_name, :not => 'an option'
  #       }).to raise_error ArgumentError
  #     end
  #   end

  #   context 'with valid parameters' do
  #     it 'should construct the request properly' do
  #       response = auth_client.get("v2/blog/#{own_blog_username}.tumblr.com/followers", limit: 1)
  #       expect(response).to be_instance_of Hash
  #       expect(response['users']).to be_instance_of Array
  #       sleep(sleep_interval)
  #       r = auth_client.followers own_blog_username, limit: 1
  #       expect(r).to eq(response)
  #     end
  #   end
  # end # describe :followers

  # describe :blog_following do
  #   context 'with valid parameters' do
  #     it 'should construct the request properly' do
  #       response = auth_client.get("v2/blog/#{blog_with_public_following}.tumblr.com/following", limit: 1)
  #       expect(response).to be_instance_of Hash
  #       expect(response['blogs']).to be_instance_of Array
  #       sleep(sleep_interval)
  #       r = auth_client.blog_following(blog_with_public_following, limit: 1)
  #       expect(r).to eq(response)
  #     end
  #   end

  #   context 'with invalid parameters' do
  #     it 'should raise an error' do
  #       expect(lambda {
  #         auth_client.blog_following(blog_with_public_following, not: 'an option')
  #       }).to raise_error ArgumentError
  #     end
  #   end
  # end # describe :blog_following

  # describe :followed_by do
  #   context 'with valid parameters' do
  #     it 'should construct the request properly' do
  #       response = auth_client.get("v2/blog/#{own_blog_username}.tumblr.com/followed_by", query: blog_username)
  #       expect(response).to be_instance_of Hash
  #       expect([true,false]).to include(response['followed_by'])
  #       sleep(sleep_interval)
  #       r = auth_client.followed_by(own_blog_username, blog_username)
  #       expect(r).to eq(response)
  #     end
  #   end

  #   context 'with invalid parameters' do
  #     it 'should raise an error' do
  #       expect(lambda {
  #         client.followed_by(own_blog_username, not: 'an option')
  #       }).to raise_error ArgumentError
  #     end
  #   end
  # end # describe :followed_by

  describe :blog_likes do
    context 'with invalid parameters' do
      it 'should raise an error' do
        expect(lambda {
          client.blog_likes blog_name, :not => 'an option'
        }).to raise_error ArgumentError
      end
    end

    context 'with valid parameters' do
      it 'should construct the request properly' do
        response = client.get("v2/blog/#{blog_with_public_likes}.tumblr.com/likes", limit: 1, api_key: consumer_key)
        expect(response).to be_instance_of Hash
        expect(response['liked_posts']).to be_instance_of Array
        sleep(sleep_interval)
        r = auth_client.blog_likes blog_with_public_likes, limit: 1
        post_a = response['liked_posts'][0]
        post_b = r['liked_posts'][0]
        expect(post_a['id']).to eq(post_b['id'])
      end
    end
  end # describe :blog_likes

  # describe :posts do

  #   context 'without a type supplied' do

  #     before do
  #       expect(client).to receive(:get).once.with("v2/blog/#{blog_name}/posts", {
  #         :limit => 1,
  #         :api_key => consumer_key
  #       }).and_return('response')
  #     end

  #     it 'should construct the request properly' do
  #       r = client.posts blog_name, :limit => 1
  #       expect(r).to eq('response')
  #     end

  #   end

  #   # REVIEW: Post types deprecated.
  #   # context 'when supplying a type' do
  #   #   before do
  #   #     expect(client).to receive(:get).once.with("v2/blog/#{blog_name}/posts/audio", {
  #   #       :limit => 1,
  #   #       :api_key => consumer_key,
  #   #       :type => 'audio'
  #   #     }).and_return('response')
  #   #   end
  #   #   it 'should construct the request properly' do
  #   #     r = client.posts blog_name, :limit => 1, :type => 'audio'
  #   #     expect(r).to eq('response')
  #   #   end
  #   # end

  # end

  # describe :get_post do
  #   context 'valid request with valid id' do
  #     before do
  #       expect(client).to receive(:get).once.with("v2/blog/#{blog_name}/posts/#{blog_post_id}").and_return('response')
  #     end
  #     it 'should construct the request properly' do
  #       r = client.get_post(blog_name, blog_post_id)
  #       expect(r).to eq('response')
  #     end
  #   end
  # end

  # # These are all just lists of posts with pagination
  # [:queue, :draft, :submissions].each do |type|

  #   ext = type == :submissions ? 'submission' : type.to_s # annoying

  #   describe type do

  #     context 'when using parameters other than limit & offset' do
  #       it 'should raise an error' do
  #         expect(lambda {
  #           client.send type, blog_name, :not => 'an option'
  #         }).to raise_error ArgumentError
  #       end
  #     end

  #     context 'with valid options' do
  #       it 'should construct the call properly' do
  #         limit = 5
  #         expect(client).to receive(:get).once.with("v2/blog/#{blog_name}/posts/#{ext}", {
  #           :limit => limit
  #         }).and_return('response')
  #         r = client.send type, blog_name, :limit => limit
  #         expect(r).to eq('response')
  #       end

  #     end

  #   end

  # end

  # describe :notifications do
  #   context 'with valid and accessible blog name' do
  #     before do
  #       expect(client).to receive(:get).once.with("v2/blog/#{own_blog_username}/notifications").and_return('response')
  #     end
  #     it 'should construct the request properly' do
  #       r = client.notifications(own_blog_username)
  #       expect(r).to eq('response')
  #     end
  #   end
  # end

  # describe :blocks do
  #   context 'with valid and accessible blog names' do
  #     it 'should block and unblock the other blog' do
  #       # Block a blog from own blog
  #       resp = client.block(own_blog_username, blog_username)
  #       expect(resp).to be_truthy

  #       sleep(2.0)

  #       # Fetch list of blocked users, ensure that blocked blog is first
  #       resp = client.blocks(own_blog_username)
  #       expect(resp).to be_instance_of Hash
  #       expect(blocked=resp['blocked_tumblelogs']).to be_instance_of Array
  #       expect(blockee=blocked.first).to be_instance_of Hash
  #       expect(blockee['name']).to eq(blog_username)

  #       # Unblock the blocked blog
  #       resp = client.unblock(own_blog_username, blog_username)
  #       expect(resp).to be_truthy

  #       sleep(2.0)

  #       # Fetch list of blocked users, ensure that blocked blog is gone
  #       resp = client.blocks(own_blog_username)
  #       blockee = resp['blocked_tumblelogs'].first
  #       expect(blockee).not_to eq(blog_username)
  #     end
  #   end
  # end

  # describe :notes do
  #   context 'with valid blog name and post id' do
  #     it 'should successfully fetch notes for given post' do
  #       resp = client.notes(blog_name, blog_post_id)
  #       expect(resp).to be_instance_of Hash
  #       expect(notes=resp['notes']).to be_instance_of Array
  #       expect(notes.first).to be_instance_of Hash
  #       expect(notes.first['type']).to be_truthy
  #     end
  #   end
  # end

end
