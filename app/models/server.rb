class Server
  include Mongoid::Document
  include Mongoid::Timestamps

  field :host, :type => String
  field :port, :type => Integer
  field :tsig_key_name, :type => String
  field :tsig_key_value, :type => String
  field :is_master, :type => Boolean

  embedded_in :group, :inverse_of => :servers
  validates_numericality_of :port, :allow_nil => true
#  validates_presence_of :host
  validates_uniqueness_of :host

#  accepts_nested_attributes_for :group
end
