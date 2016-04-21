class ImportController < ApplicationController

  def twitter
    c = current_user.categories.find_by name: 'twitter_import'
    @updates = c ? c.updates : [];
  end

end
