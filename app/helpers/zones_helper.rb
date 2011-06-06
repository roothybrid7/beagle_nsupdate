module ZonesHelper
  def link_to_items_per_page
    lambda do |count|
      link_to(count, count.to_i == 0 ? zones_path : zones_path(:per_page => count.to_i))
    end
  end

  def link_to_items_per_page_for_records(zone)
    lambda do |count|
      link_to(count, count.to_i == 0 ? all_records_zone_path : all_records_zone_path(zone, :per_page => count.to_i))
    end
  end

  def parse_rdata(rdata)
    if rdata.is_a?(Array)
      rdata.map {|d| "#{d}" }.join(' ')
    else
      "#{rdata}"
    end
  end
end
