class SendResetEmailsJob < ApplicationJob
  queue_as :mailer

  def perform(*account)
    AccountMailer.password_reset(account).deliver_later
  end
end
