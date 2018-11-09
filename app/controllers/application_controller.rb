class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #before_action :authenticate_admin_usuario!

  #before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def access_denied(exception)
    redirect_to admin_dashboard_path, alert: exception.message
  end
end
