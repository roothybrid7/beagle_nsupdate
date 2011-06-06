require 'spec_helper'

describe "groups/index.html.haml" do
  before(:each) do
    assign(:groups, [
      stub_model(Group),
      stub_model(Group)
    ])
  end

  it "renders a list of groups" do
    render
  end
end
