require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = Account.new(display_name: "Example", email: "account@example.com",
                                                            password: "password1", password_confirmation: "password1")
  end

  test "should be valid" do
    assert @account.valid?
  end

  test "name should be under 50 chars" do
    @account.display_name = "a" * 101
    assert_not @account.valid?
  end

  test "email should be under 255 chars" do
    @account.email = "a" * 244 + "@example.com"
    assert_not @account.valid?
  end

  test "email should be present" do
    @account.email = "    "
    assert_not @account.valid?
  end

  test "valid email addresses should be accepted" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn me@gmail.com]
    valid_addresses.each do |valid_address|
        @account.email = valid_address
        assert @account.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "invalid email addresses should be rejected" do
    invalid_addresses = %w[userexample.com USERfooCOM A_US-ERfoo@bar..org
                         first.last.foo@jp alice+bobbaz:cn me->gmail.com]
    invalid_addresses.each do |invalid_address|
        @account.email = invalid_address
        assert_not @account.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate = @account.dup
    duplicate.email = @account.email.upcase
    @account.save
    assert_not duplicate.valid?
  end

  test "email addresses should be saved as lowercase" do
    mixed_case = "aNtHoNy@gMaIl.CoM"
    @account.email = mixed_case
    @account.save

    assert_equal mixed_case.downcase, @account.reload.email
  end

  test "password should be present" do
    @account.password = @account.password_confirmation = "  " * 8
    assert_not @account.valid?
  end

  test "password should have minimum length" do
    @account.password = @account.password_confirmation = "a" * 7
    assert_not @account.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @account.authenticated?(:remember, '')
  end
end
