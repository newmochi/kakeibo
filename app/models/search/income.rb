class Search::Income < Search::Base
  ATTRIBUTES = %i(
    fromdate todate
    fromkindx tokindx
    fromvalue
    iperson
    ifrom
    iobject
  )
  attr_accessor(*ATTRIBUTES)

  def matches
    t = ::Income.arel_table
    results = ::Income.all
    if fromdate.present?
      results = results.where(t[:idate].gteq(fromdate))
    end
    if todate.present?
      results = results.where(t[:idate].lteq(todate))
    end

    if fromkindx.present?
      results = results.where(t[:ikindx].gteq(fromkindx))
    end
    if tokindx.present?
      results = results.where(t[:ikindx].lteq(tokindx))
    end

    if fromvalue.present?
      results = results.where(t[:ivalue].gteq(fromvalue))
    end

    results = results.where(t[:iperson] == iperson) if iperson.present?
    results = results.where(contains(t[:ifrom], ifrom)) if ifrom.present?
    results = results.where(contains(t[:iobject], iobject)) if iobject.present?
    results
  end
end