class AddLinkedListToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :next, index: true
    add_reference :lists, :next_post
  end
end
