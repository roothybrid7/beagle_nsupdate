require 'spec_helper'

describe "zones/index.html.haml" do
  before(:each) do
    assign(:zones, [
      stub_model(Zone),
      stub_model(Zone)
    ])
  end

  it "renders a list of zones" do
    render
  end
end
