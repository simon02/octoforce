require 'rails_helper'
RSpec.describe AnalyticsWorker, type: :worker do

  def index
    @updates = current_user.updates.published.order(:published_at)
  end

end
