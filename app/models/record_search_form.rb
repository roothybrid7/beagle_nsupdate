# coding: utf-8

class RecordSearchForm < SearchForm
  attr_accessor :type

  def initialize(params)
    super
    self.type = params[:type] if params
  end

  def persisted?
    false
  end
end
