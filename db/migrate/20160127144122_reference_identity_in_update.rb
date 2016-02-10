class ReferenceIdentityInUpdate < ActiveRecord::Migration
  def change
    add_reference :updates, :identity, index: true, foreign_key: true
  end
end
