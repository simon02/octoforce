require 'rails_helper'

RSpec.describe SocialMediaWorker, type: :worker do

  describe '#generate_short_links' do
    it 'can handle a single link' do
      result = SocialMediaWorker.generate_short_links 'www.google.com'
      expect(Shortener::ShortenedUrl.count).to eq 1
      expect(result).to eq "shorten.octoforce-app.dev/" + Shortener::ShortenedUrl.first.unique_key
    end

    it 'can handle a text with a single link' do
      result = SocialMediaWorker.generate_short_links 'some testing test for www.google.com - haha'
      expect(Shortener::ShortenedUrl.count).to eq 1
      expect(result).to eq "some testing test for shorten.octoforce-app.dev/" + Shortener::ShortenedUrl.first.unique_key + " - haha"
    end

    it 'can handle multiple links' do
      result = SocialMediaWorker.generate_short_links 'link1 is google.com then comes http://facebook.co'
      expect(Shortener::ShortenedUrl.count).to eq 2
      expect(result).to eq "link1 is shorten.octoforce-app.dev/" + Shortener::ShortenedUrl.first.unique_key + " then comes shorten.octoforce-app.dev/" + Shortener::ShortenedUrl.last.unique_key
    end

    it 'can handle multiple times the same link' do
      result = SocialMediaWorker.generate_short_links 'www.example.co www.example.co and another one www.example.co'
      expect(Shortener::ShortenedUrl.count).to eq 1
      expect(result.scan(Shortener::ShortenedUrl.first.unique_key).count).to eq 3
    end
  end

end
