class Zone
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, :type => String
  belongs_to :group, :inverse_of => :zones
  validates_presence_of :name, :group
  validates_uniqueness_of :name
end
