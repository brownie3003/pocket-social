require 'spec_helper'

describe "Authentication" do
    
    subject { page }
    
    describe "signin" do
        before { visit signin_path }
        
        it { should have_content('Sign in') }
        
        describe "with invalid information" do
            before { click_button "Sign in" }
            
            it { should have_title("Sign in") }
            it { should have_selector('div.alert.alert-error') }
        end
        
        describe "with valid information" do
            Mongoid.purge!
            user = Fabricate(:user)
            before do
                fill_in "Email", with: user.email.upcase
                fill_in "Password", with: user.password
                click_button "Sign in"
            end
            
            it { should have_link('Sign out', href: signout_path) }
            it { should_not have_link('Sign in', href: signin_path) }
        end
    end
end
