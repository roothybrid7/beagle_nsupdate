class ApplicationController < ActionController::Base
  before_filter :authenticate_user!

  protect_from_forgery

  protected

  def authenticate_inviter!
    authenticate_user!
  end

  private

  def detect_locale
    I18n.locale = request.headers['Accept-Language'].scan(/^[a-z]{2}/).first
  end
end
