json.array!(@surgeries) do |surgery|
  json.extract! surgery, :id
  json.url surgery_url(surgery, format: :json)
end
