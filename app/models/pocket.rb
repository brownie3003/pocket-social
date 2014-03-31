class Pocket
  include Mongoid::Document
  field :username, type: String
  field :token, type: String
  
  embedded_in :user
end
