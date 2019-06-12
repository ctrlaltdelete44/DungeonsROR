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
    end
end
