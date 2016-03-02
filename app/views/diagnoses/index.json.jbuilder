json.array!(@diagnoses) do |diagnosis|
  json.extract! diagnosis, :id
  json.url diagnosis_url(diagnosis, format: :json)
end
