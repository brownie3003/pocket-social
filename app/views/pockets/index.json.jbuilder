json.array!(@pockets) do |pocket|
  json.extract! pocket, :id, :username, :token
  json.url pocket_url(pocket, format: :json)
end
