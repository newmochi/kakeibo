json.array!(@expenses) do |expense|
  json.extract! expense, :id, :exdate, :exvalue, :experson, :exkindx, :exkindy, :exfrom, :exnotice, :exdiary, :exdetail
  json.url expense_url(expense, format: :json)
end
