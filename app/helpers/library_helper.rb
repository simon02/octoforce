module LibraryHelper

  def calculate_category_amount category
    category.posts.size
  end

  def category_amount_tooltip
    'number of posts in this category'
  end

  def filter_keys
    %w{category}
  end

end
