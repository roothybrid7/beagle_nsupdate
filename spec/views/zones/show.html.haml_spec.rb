require 'spec_helper'

describe "zones/show.html.haml" do
  before(:each) do
    @zone = assign(:zone, stub_model(Zone))
  end

  it "renders attributes in <p>" do
    render
  end
end
