require 'spec_helper'

describe "zones/edit.html.haml" do
  before(:each) do
    @zone = assign(:zone, stub_model(Zone))
  end

  it "renders the edit zone form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => zones_path(@zone), :method => "post" do
    end
  end
end
