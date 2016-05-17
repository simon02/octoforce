module CategoriesHelper

  def identities
    current_user.identities
  end

  def calculate_category_amount category
    category.posts.size
  end

  def category_amount_tooltip
    "amount of posts in this category"
  end

end
