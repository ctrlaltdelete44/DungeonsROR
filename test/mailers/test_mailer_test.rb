# frozen_string_literal: true

require 'test_helper'

class TestMailerTest < ActionMailer::TestCase
  test 'test_emails' do
    account = accounts(:ferris)
    mail = TestMailer.test_emails(account)
    assert_equal 'Test email', mail.subject
    assert_equal [account.email], mail.to
    assert_equal ['noreply@dungeons.com'], mail.from
    assert_match account.display_name + ' has requested a test email', mail.body.encoded
  end
end
