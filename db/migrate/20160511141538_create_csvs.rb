class CreateCsvs < ActiveRecord::Migration
  def change
    create_table :csvs do |t|
      t.references :user, index: true, foreign_key: true

      t.attachment :file
      t.integer :processed, default: 0
      t.integer :succeeded, default: 0
      t.boolean :finished, default: false

      t.timestamps null: false
    end
  end
end
