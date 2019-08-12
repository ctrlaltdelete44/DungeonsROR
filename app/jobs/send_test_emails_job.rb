# frozen_string_literal: true

class SendTestEmailsJob < ApplicationJob
  queue_as :mailer

  def perform(account)
    @account = account
    TestMailer.test_emails(@account).deliver_later
  end
end
