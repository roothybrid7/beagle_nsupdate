require 'spec_helper'

describe "groups/show.html.haml" do
  before(:each) do
    @group = assign(:group, stub_model(Group))
  end

  it "renders attributes in <p>" do
    render
  end
end
