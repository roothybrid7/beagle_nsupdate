module ApplicationHelper
  def count_list_per_page
    BeagleNsupdate::Application.config.count_list_per_page
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("#{association}/form", :f => builder)
    end
    link_to_function(name, raw("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def link_to_remove_fields_tag(name, association)
    hidden_field(association, :_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields_tag(name, view, association)
    link_to_function(name, raw("add_fields(this, \"#{association}\", \"#{escape_javascript(render(view))}\")"))
  end
end
