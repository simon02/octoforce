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
    c = current_user.categories.find_by name: 'twitter_import'
    @updates = c ? c.updates : [];
  end

  def step3
    current_user.update onboarding_step: 3
    @schedules = current_user.schedules
    @categories = current_user.categories.includes(:posts)
  end

  def step4
    current_user.update onboarding_active: false
    @filtering_params = filtering_params
    @updates = current_user.updates.published(false).includes(:identity, :category).filter(@filtering_params).sorted.group_by { |u| u.scheduled_at.to_date }
    @identities = current_user.identities.includes(:updates)
    @categories = current_user.categories.includes(:updates)
  end

  private

  def filtering_params
    params.slice(:category, :identity)
  end

end
