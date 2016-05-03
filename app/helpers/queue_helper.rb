module QueueHelper

  def calculate_category_amount category
    # making sure we don't hit the DB again (no where, no count)
    # TK we should actually be able to filter updates on scheduled in the query.. but can't figure it out :(
    category.updates.select { |u| !u.published }.size
  end

  def category_amount_tooltip
    'number of scheduled updates'
  end

  def calculate_identity_amount identity
    # same as above
    identity.updates.select { |u| !u.published }.size
  end

  def identity_amount_tooltip
    'number of scheduled updates'
  end

  def filter_keys
    %w{category identity}
  end

end
