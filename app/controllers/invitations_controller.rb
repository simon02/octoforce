class InvitationsController < Devise::InvitationsController
  def update
    super { |resource|
      MailchimpWorker.perform_async MailchimpWorker::TYPE_BETA_SUBSCRIPTION, email: resource.email
    }
  end
end
