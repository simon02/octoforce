class AddProvidersToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :providers, :string, default: []
    reversible do |direction|
      direction.up { Post.update_all providers: ['twitter'] }
    end
  end
end
