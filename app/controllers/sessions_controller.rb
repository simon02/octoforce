class SessionsController < Devise::SessionsController
  skip_before_filter :onboarding
end
