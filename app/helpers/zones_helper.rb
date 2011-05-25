module ZonesHelper
  def parse_rdata(rdata)
    if rdata.is_a?(Array)
      rdata.map {|d| "#{d}" }.join(' ')
    else
      "#{rdata}"
    end
  end
end
