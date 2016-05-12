class CreateOnboardings < ActiveRecord::Migration
  def change
    create_table :onboardings do |t|

      t.timestamps null: false
    end
  end
end
