class User
  include Mongoid::Document
  field :username
  field :email
  # Must use username as ID because .com of email doesn't work for routes
  field :_id, type: String, default: ->{ username }
  field :password
  field :pocket, type: Hash

  validates_presence_of :email, :password
  validates_uniqueness_of :email, :username
  # validates_format_of :email , with: /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/
end
