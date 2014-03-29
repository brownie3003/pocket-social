json.array!(@users) do |user|
  json.extract! user, :id, :username, :pocket_token
  json.url user_url(user, format: :json)
end
