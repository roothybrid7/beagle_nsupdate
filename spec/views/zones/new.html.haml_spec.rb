require 'spec_helper'

describe "zones/new.html.haml" do
  before(:each) do
    assign(:zone, stub_model(Zone).as_new_record)
  end

  it "renders new zone form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => zones_path, :method => "post" do
    end
  end
end
