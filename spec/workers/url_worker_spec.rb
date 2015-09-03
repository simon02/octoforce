require 'rails_helper'

RSpec.describe UrlWorker, type: :worker do

  describe '#perform' do
    it 'should perform' do
      user = User.create bitly_login: ENV["BITLY_TEST_LOGIN"], bitly_api_key: ENV["BITLY_TEST_API_KEY"]
      id = Identity.create user: user, provider: 'test', uid: '123'
      ci = ContentItem.create text: "a lot of text at http://justdoit.co/alkla?param=1231&param2=some adf", identity: id
      u = UrlWorker.new
      VCR.use_cassette("url_worker/test_perform") do
        u.perform(ci.id)
        expect(ci.reload.text).to eq("a lot of text at http://bit.ly/1Knp9P6 adf")
      end
    end

    it 'should also work without bitly' do
      text = "a lot of text at http://justdoit.co/alkla?param=1231&param2=some adf"
      ci = ContentItem.create text: text, identity: (Identity.create user: User.create(), provider: 'test', uid: '123')
      u = UrlWorker.new
      u.perform(ci.id)
      expect(ci.reload.text).to eq(text)
    end
  end

  describe '#replace_with_bitly' do
    it 'should replace a single link' do
      text = "http://www.something.com"
      bitly_client = Bitly.new ENV["BITLY_TEST_LOGIN"], ENV["BITLY_TEST_API_KEY"]
      VCR.use_cassette("url_worker/single_link") do |c|
        new_text = UrlWorker.replace_with_bitly_links text, bitly_client
        expect(new_text).to eq("http://bit.ly/1JrIk4u")
      end
    end

    it 'should replace a single link in a block of text' do
      text = "a lot of text\n over multiple lines http://www.something.com containing a link"
      bitly_client = Bitly.new ENV["BITLY_TEST_LOGIN"], ENV["BITLY_TEST_API_KEY"]
      VCR.use_cassette("url_worker/single_link_in_text") do |c|
        new_text = UrlWorker.replace_with_bitly_links text, bitly_client
        expect(new_text).to eq("a lot of text\n over multiple lines http://bit.ly/1JrIk4u containing a link")
      end
    end

    it 'should replace multiple links in a block of text' do
      text = "a lot of text at http://justdoit.co/alkla?param=1231&param2=something\n over multiple lines http://www.something.com containing a link"
      bitly_client = Bitly.new ENV["BITLY_TEST_LOGIN"], ENV["BITLY_TEST_API_KEY"]
      VCR.use_cassette("url_worker/multiple_links_in_text") do |c|
        new_text = UrlWorker.replace_with_bitly_links text, bitly_client
        expect(new_text).to eq("a lot of text at http://bit.ly/1JrIIA0\n over multiple lines http://bit.ly/1JrIk4u containing a link")
      end
    end
  end

end
