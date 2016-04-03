require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe SocialMediaWorker, type: :worker do

  describe '#perform_facebook' do
    it 'should perform' do
    end
  end

end
