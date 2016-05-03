class Search::Expense < Search::Base
  ATTRIBUTES = %i(
    fromdate todate
    fromkindx tokindx
    fromvalue
    experson
    exfrom
    exobject
  )
  attr_accessor(*ATTRIBUTES)

  def matches
    t = ::Expense.arel_table
    results = ::Expense.all
    if fromdate.present?
      results = results.where(t[:exdate].gteq(fromdate))
    end
    if todate.present?
      results = results.where(t[:exdate].lteq(todate))
    end

    if fromkindx.present?
      results = results.where(t[:exkindx].gteq(fromkindx))
    end
    if tokindx.present?
      results = results.where(t[:exkindx].lteq(tokindx))
    end

    if fromvalue.present?
      results = results.where(t[:exvalue].gteq(fromvalue))
    end

    results = results.where(t[:experson] == experson) if experson.present?
    results = results.where(contains(t[:exfrom], exfrom)) if exfrom.present?
    results = results.where(contains(t[:exobject], exobject)) if exobject.present?
    results
  end
end