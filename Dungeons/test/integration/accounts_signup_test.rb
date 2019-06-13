require 'test_helper'

class AccountsSignupTest < ActionDispatch::IntegrationTest
    test "invalid signup information" do
            get signup_path
            assert_no_difference 'Account.count' do
                post signup_path, params: { account: { display_name: "",
                                                                                                 email: "user@invalid",
                                                                                                 password: "egg",
                                                                                                 password_confirmation: "boy" } }
            end
            assert_template 'accounts/new'

            assert_select "p.error-msg", "Email is invalid"
            assert_select "p.error-msg", "Password confirmation doesn't match Password"
            assert_select "p.error-msg", "Password is too short (minimum is 8 characters)"
    end
end
