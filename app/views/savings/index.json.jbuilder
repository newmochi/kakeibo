json.array!(@savings) do |saving|
  json.extract! saving, :id, :scheckdate, :svalue, :sperson, :skindx, :skindy, :sfrom, :snotice, :sdiary, :sdetail
  json.url saving_url(saving, format: :json)
end
