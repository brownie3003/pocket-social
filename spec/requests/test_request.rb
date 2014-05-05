require "spec_helper"

describe "Test" do
    # Mongoid.purge!
    user = Fabricate(:user)
    puts user.email
    user1 = User.find_by(email: user.email)
    puts user1.username
end
