class SendActivationEmailsJob < ApplicationJob
  queue_as :mailer

  def perform(account)
    @account = account
    AccountMailer.account_activation(@account).deliver_later
  end
end
