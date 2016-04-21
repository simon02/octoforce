module AnalyticsHelper

  def calculate_category_amount category
    category.updates.published.count
  end

  def category_amount_tooltip
    'number of published updates'
  end

  def calculate_identity_amount identity
    identity.updates.published.count
  end

  def identity_amount_tooltip
    'number of published updates'
  end

  def filter_keys
    %w{category identity}
  end

end

