module AnalyticsHelper

  def calculate_category_amount category
    # making sure we don't hit the DB again (no where, no count)
    category.updates.select(&:published).size
  end

  def category_amount_tooltip
    'number of published updates'
  end

  def calculate_identity_amount identity
    # making sure we don't hit the DB again (no where, no count)
    identity.updates.select(&:published).size
  end

  def identity_amount_tooltip
    'number of published updates'
  end

  def filter_keys
    %w{category identity}
  end

end

