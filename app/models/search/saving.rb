class Search::Saving < Search::Base
  ATTRIBUTES = %i(
    fromdate todate
    fromkindx tokindx
    fromvalue
    sperson
    sfrom
    sobject
  )
  attr_accessor(*ATTRIBUTES)

  def matches
    t = ::Saving.arel_table
#    results = ::Saving.all
    results = ::Saving.includes( :saverecords ).all
    if fromdate.present?
      results = results.where(t[:scheckdate].gteq(fromdate))
    end
    if todate.present?
      results = results.where(t[:scheckdate].lteq(todate))
    end

    if fromkindx.present?
      results = results.where(t[:skindx].gteq(fromkindx))
    end
    if tokindx.present?
      results = results.where(t[:skindx].lteq(tokindx))
    end

    if fromvalue.present?
      results = results.where(t[:svalue].gteq(fromvalue))
    end

    results = results.where(t[:sperson] == sperson) if sperson.present?
    results = results.where(contains(t[:sfrom], sfrom)) if sfrom.present?
    results = results.where(contains(t[:sobject], sobject)) if sobject.present?
    results
  end
end