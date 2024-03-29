require 'integration_test_helper'
include Warden::Test::Helpers

class SignInFlowTest < ActionDispatch::IntegrationTest

  setup do
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
  end

  teardown do
    Warden.test_reset!
  end

  def sign_out
    visit '/'
    within("div#above-header") do
      click_on("Logout")
    end
  end

  test "a browser should be able to sign in and be shown the home page" do
    sign_in
    assert_equal '/en', current_path
    sign_out
  end

  test "an admin should be able to sign in and be shown the admin page" do
    sign_in("admin@test.com")
    assert_equal '/admin', current_path
    sign_out
  end

  test "a browser visiting an admin page should be redirected to login in their locale" do
    visit '/admin'
    assert_equal '/en/users/sign_in', current_path
  end

end
