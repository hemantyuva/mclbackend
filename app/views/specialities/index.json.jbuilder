json.array!(@specialities) do |speciality|
  json.extract! speciality, :id, :name
  json.url speciality_url(speciality, format: :json)
end
