module QueueHelper

  def calculate_category_amount category
    category.updates.scheduled.count
  end

  def category_amount_tooltip
    'number of scheduled updates'
  end

  def calculate_identity_amount identity
    identity.updates.scheduled.count
  end

  def identity_amount_tooltip
    'number of scheduled updates'
  end

  def filter_keys
    %w{category identity}
  end

end
