require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context "User" do
    should "be able to create a new user via auth_hash" do
      auth_hash = { "provider" => "test",
                    "uid" => "10",
                    "info" => {"name" => "Test User"},
                    "credentials" => { "token" => "TESTTOKEN" }}
      user = User.find_or_create_by_auth_hash(auth_hash)
      assert_not_nil user
      assert_equal "Test User", user.name
      assert user.persisted?

      assert_includes user.authorizations,
                      Authorization.find_by(provider: "test", uid: "10")
    end
    should "be able to find an existing user via auth_hash" do
      auth = authorizations(:one)
      auth_hash = { "provider" => auth.provider,
                    "uid" => auth.uid,
                    "info" => {},
                    "credentials" => { "token" => auth.token } }

      user = User.find_or_create_by_auth_hash(auth_hash)
      assert_equal auth.user, user
    end
  end

  # context "a user" do
  #   should validate_presence_of(:name)
  # end
end
