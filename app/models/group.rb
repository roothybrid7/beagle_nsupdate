# coding: utf-8

class Group
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :description, :type => String
  field :port, :type => Integer
  field :tsig_key_name, :type => String
  field :tsig_key_value, :type => String

  embeds_many :servers
  has_many :zones
  has_many :foos

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :port, :allow_nil => true
  validates_associated :servers

  accepts_nested_attributes_for :servers, :allow_destroy => true,
    :reject_if => lambda {|attrs| attrs[:host].blank? }
  accepts_nested_attributes_for :zones, :allow_destroy => true,
    :reject_if => lambda {|attrs| attrs[:name].blank? }
end
