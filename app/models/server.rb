class Server
  include Mongoid::Document
  include Mongoid::Timestamps
  field :host, :type => String
  field :port, :type => Integer
  field :tsig_name, :type => String
  field :tsig_value, :type => String
  embedded_in :group, :inverse_of => :servers
  validates_presence_of :host
end
