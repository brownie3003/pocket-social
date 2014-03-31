class Pocket
  include Mongoid::Document
  field :username, type: String
  field :access_token, type: String
  
  embedded_in :user
end
