# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/test_mailer
class TestMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/test_mailer/test_emails
  def test_emails
    account = Account.first
    TestMailer.test_emails(account)
  end
end
