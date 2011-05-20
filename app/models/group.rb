class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, :type => String
  field :port, :type => Integer
  field :tsig_name, :type => String
  field :tsig_value, :type => String
  embeds_many :servers
  has_many :zones
  validates_presence_of :name
  validates_associated :servers
  validates_uniqueness_of :name
end
