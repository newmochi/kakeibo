json.array!(@saverecords) do |saverecord|
  json.extract! saverecord, :id, :saving_id, :srnowdate, :srnowvalue, :srnownotice, :srnowdiary, :srnowdetail, :srnextdate
  json.url saverecord_url(saverecord, format: :json)
end
