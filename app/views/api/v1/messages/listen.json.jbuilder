json.array! @messages do |message|
  json.extract! message, :content, :phone_number
end
