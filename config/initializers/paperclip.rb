# coding: utf-8

Paperclip::Attachment.default_options.update({
  :storage => :fog,
  :fog_credentials => {
    :provider => "AWS",
    :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
    :region => ENV['AWS_REGION']
  },
  :fog_directory => ENV["AWS_BUCKET_NAME"]
})
