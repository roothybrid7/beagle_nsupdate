require 'spec_helper'

describe Server do
  it { should be_embedded_in(:group).as_inverse_of(:servers) }
end
