require 'test_helper'


class AccountsLoginTest < ActionDispatch::IntegrationTest

    def setup
        @account = accounts(:ferris)
    end

#test for flashes lasting for a page too long after error in login
    test "login with invalid information" do
        get login_path
        assert_template 'sessions/new'
        post login_path, params: { session: { email: "", password: "" } }
        assert_template 'sessions/new'
        assert_not flash.empty?
        get root_path
        assert flash.empty?
    end

#test for links appearing correctly on login
    test "login with valid information followed by logout" do
        get login_path
        assert_template 'sessions/new'
        post login_path, params: {session: { email:              @account.email,
                                                                                 password:    'password' } }
        assert is_logged_in?
        assert_redirected_to @account
        follow_redirect!
        assert_template 'accounts/show'
        assert_select "a[href=?]", login_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_select "a[href=?]", account_path(@account)

         delete logout_path
         assert_not is_logged_in?
         assert_redirected_to root_url
         follow_redirect!
         assert_select "a[href=?]", login_path
        assert_select "a[href=?]", logout_path, count: 0
        assert_select "a[href=?]", account_path(@account), count: 0
    end
end
