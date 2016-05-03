class Search::Saverecord < Search::Base
  ATTRIBUTES = %i(
    fromdate todate
    fromkindx tokindx
    fromvalue
  )
  attr_accessor(*ATTRIBUTES)

  def matches
    t = ::Saverecord.arel_table
    results = ::Saverecord.all
    if fromdate.present?
      results = results.where(t[:srnowdate].gteq(fromdate))
    end
    if todate.present?
      results = results.where(t[:srnowdate].lteq(todate))
    end

#    if fromkindx.present?
#      results = results.where(t[:saving_id.skindx].gteq(fromkindx))
#    end
#    if tokindx.present?
#      results = results.where(t[saving_id.skindx].lteq(tokindx))
#    end

    if fromvalue.present?
      results = results.where(t[:srnowvalue].gteq(fromvalue))
    end

    results
  end
end