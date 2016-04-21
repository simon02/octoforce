class AddLastCheckedToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :last_checked, :string
  end
end
