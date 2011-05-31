class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  protect_from_forgery

  protected

  def authenticate_inviter!
    authenticate_user!
  end
end
