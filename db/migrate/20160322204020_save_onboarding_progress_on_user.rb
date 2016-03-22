class SaveOnboardingProgressOnUser < ActiveRecord::Migration
  def up
    add_column :users, :onboarding_step, :integer, limit: 1, default: 0
    add_column :users, :onboarding_active, :boolean, default: true
    User.reset_column_information
    User.all.each do |user|
      user.update onboarding_active: false
    end
  end
  def down
    remove_column :users, :onboarding_step
    remove_column :users, :onboarding_active
  end
end
