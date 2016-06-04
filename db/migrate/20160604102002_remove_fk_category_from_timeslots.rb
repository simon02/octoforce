class RemoveFkCategoryFromTimeslots < ActiveRecord::Migration
  def change
    remove_foreign_key :timeslots, column: :category_id
   end
end
