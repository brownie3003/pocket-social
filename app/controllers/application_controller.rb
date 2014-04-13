class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper 
  include PocketsHelper
  include UsersHelper
  
  def default_url_options
    if Rails.env.production?
      {:host => "myproduction.com"}
    else  
      {}
    end
  end
end
