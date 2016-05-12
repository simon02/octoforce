module IdentitiesHelper
  def provider_type identity
    identity.provider.split('_').first
  end
end
