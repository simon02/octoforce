class AssetsController < ApplicationController

  def create
    asset = Asset.new asset_params
    asset.user = current_user
    if asset.save
      render json: asset, status: 201
    else
      render json: nil, status: 400
    end
  end

  def destroy
    asset = Asset.find_by id: params[:id]
    if asset
      render json: asset.destroy
    else
      render json: nil, status: 401
    end
  end

  private

  def asset_params
    params.require(:asset).permit(:media)
  end

end
