class OnboardingController < ApplicationController
  skip_before_filter :onboarding
  layout 'onboarding'
  layout 'application', only: [:step4]

  def step1
    current_user.update onboarding_step: 1
    @identities = current_user.identities
  end

  def step2
    current_user.update onboarding_step: 2
    @posts = current_user.posts
    @categories = current_user.categories
  end

  def step3
    current_user.update onboarding_step: 3
    @schedules = current_user.schedules
  end

  def step4
    current_user.update onboarding_active: false
    @identities = current_user.identities
    @categories = current_user.categories
    @updates = current_user.updates.scheduled.sorted.group_by { |u| u.scheduled_at.to_date }
  end

end
