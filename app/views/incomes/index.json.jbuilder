json.array!(@incomes) do |income|
  json.extract! income, :id, :idate, :ivalue, :iorgvalue, :iperson, :ikindx, :ikindy, :ifrom, :inotice, :idiary, :idetail
  json.url income_url(income, format: :json)
end
