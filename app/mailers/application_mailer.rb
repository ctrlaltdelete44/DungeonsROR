# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@dungeons.com'
  layout 'mailer'
end
