class AssetWorker
  include Sidekiq::Worker

  def perform asset_id, url
    asset = Asset.find_by id: asset_id
    if asset
      asset.media = open(url)
      asset.save
    end
  end

end
