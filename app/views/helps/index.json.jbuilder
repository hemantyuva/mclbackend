json.array!(@helps) do |help|
  json.extract! help, :id
  json.url help_url(help, format: :json)
end
