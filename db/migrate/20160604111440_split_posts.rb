class SplitPosts < ActiveRecord::Migration
  def up
    Post.each do |p|
      TwitterPost.create text: p.text, asset: p.asset, post: p, created_at: p.created_at
      if p.link
        FacebookPost.create(
          text: p.text,
          url: p.link.url,
          title: p.link.title,
          caption: p.link.caption,
          description: p.link.description,
          asset: p.asset,
          post: p,
          created_at: p.created_at)
      end
    end
    remove_column :posts, :text
    remove_reference :posts, :asset
    remove_table :links
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
