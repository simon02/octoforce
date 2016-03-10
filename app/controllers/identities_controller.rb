class IdentitiesController < ApplicationController

  def index
    @identities = current_user.identities
  end

  def destroy
    i = Identity.find_by id: params['id']
    if i && i.destroy
      flash[:success] = "Social network has been removed."
    end
    redirect_to identities_url
  end

end
