class Subscriptions
  include Mongoid::Document
  field :subscriptions, type: Array
  field :subscribers, type: Array
  
  embedded_in :user
end
