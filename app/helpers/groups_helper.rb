module GroupsHelper
  def link_to_items_per_page
    lambda {|count| link_to(count, count.to_i == 0 ? groups_path : groups_path(:per_page => count.to_i)) }
  end

#  def link_to_add_fields(name, f, association)
#    @group.servers.build
#logger.debug(f.object.servers)
#    new_object = f.object.class.reflect_on_association(association).klass.new
#    fields = render("#{association}/form", :locals => {:form => f})

#    link_to_function(name, raw("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
#  end
end
