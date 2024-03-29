class OnboardingController < ApplicationController

  def check
    if current_user && current_user.onboarding_active && current_user.onboarding_step == 0
      redirect_to action: 'step1'
    else
      redirect_to queue_path
    end
  end

  def step1
    current_user.update onboarding_step: 1
    @identities = current_user.identities
  end

  def step2
    current_user.update onboarding_step: 2
    @posts = current_user.posts
    @post = Post.new
    current_user.identities.each { |identity| @post.social_media_posts.build identity: identity }
    @post.text = 'Testing this new rescheduling tool by @octoforce #socialmedia #automation #testing' if @posts.empty?
    @categories = current_user.categories
    c = current_user.categories.find_by name: 'twitter_import'
    @updates = c ? c.updates : [];
  end

  def step3
    current_user.update onboarding_step: 3
    @post = current_user.posts.last
    @timeslots = current_user.timeslots
    @categories = current_user.categories.includes(:posts)
    @identities = current_user.identities
    @slot = Timeslot.new
    if @identities.size == 1
      @slot.identity_ids = @identities.map &:id
    end
  end

  def step3_publish
    slot = Timeslot.create_with_timestamp timeslot_params.merge(user: current_user)
    SchedulingFacade.reschedule_category slot.category, 2
    redirect_to action: 'step4'
  end

  def step4
    current_user.update onboarding_step: 4
    # current_user.update onboarding_active: false
    @filtering_params = filtering_params
    @updates = current_user.updates.published(false).includes(:identity, :category).filter(@filtering_params).sorted
    @identities = current_user.identities.includes(:updates)
    @categories = current_user.categories.includes(:updates)
    @timeslot = current_user.timeslots.first
  end

  def step5
    current_user.update onboarding_step: 5
    @post = Post.new
    current_user.identities.each { |identity| @post.social_media_posts.build identity: identity }
  end

  def step6
    current_user.update onboarding_step: 6, onboarding_active: false
  end

  private

  def filtering_params
    params.slice(:category, :identity)
  end

  def timeslot_params
    params.require(:timeslot).permit(:schedule_id, :day, :offset, :category_id)
  end

end
