require 'spec_helper'

describe "User pages" do
    subject { page }
    
    describe "profile page" do
        let(:user) { FactoryGirl.create(:user) }
        before { visit user_path(user) }
        
        it { should have_content(user.username) }
    end
    
    describe "signup page" do
        before { visit signup_path }
        
        let(:submit) { "Create my account" }
        
        it { should have_content('Sign up') }
        
        describe "with invalid information" do
            it "should not create a user" do
                expect { click_button submit}.not_to change(User, :count)
            end
        end
        
        describe "with valid information" do
            before do
                fill_in "Username", with: "Example"
                fill_in "Email", with: "user@example.com"
                fill_in "Password", with: "foobar28"
                fill_in "Re-type password", with: "foobar28"
            end
            
            it "should create a user" do
                expect { click_button submit }.to change(User, :count).by(1)
            end
        end
    end
end
