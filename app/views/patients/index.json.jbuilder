json.array!(@patients) do |patient|
  json.extract! patient, :id, :firstname, :middlename, :lastname
  json.url patient_url(patient, format: :json)
end
