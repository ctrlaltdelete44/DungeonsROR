require 'test_helper'

class AccountMailerTest < ActionMailer::TestCase
  test "account_activation" do
	account = accounts(:ferris)
	account.activation_token = Account.new_token
	mail = AccountMailer.account_activation(account)

    assert_equal "Account Activation",		mail.subject
    assert_equal [account.email],			mail.to
    assert_equal ["noreply@example.com"],	mail.from
    assert_match account.display_name,				mail.body.encoded
	assert_match account.activation_token,	mail.body.encoded
	assert_match CGI.escape(account.email), mail.body.encoded
  end

  test "password_reset" do
    mail = AccountMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
