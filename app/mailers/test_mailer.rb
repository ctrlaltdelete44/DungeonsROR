# frozen_string_literal: true

class TestMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.test_mailer.test_emails.subject
  #
  def test_emails(account)
    @account = account
    mail to: account.email, subject: 'Test email'
  end
end
