class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, Identity, user_id: user.id
    can :manage, Category, user_id: user.id
    can :manage, Post, user_id: user.id
    can :manage, Schedule, user_id: user.id
    can :manage, Timeslot, schedule: { user_id: user.id }
    can :manage, Update, user_id: user.id
    can :manage, User, id: user.id
  end
end
