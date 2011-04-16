class Admin::OpenbravoSettingsController < Admin::BaseController

  def edit
    @organizations = Rails.cache.fetch('openbravo-organizations-list') do
      Openbravo::Organization.all.map{|org| [org.identifier, org.id].flatten.uniq }
    end
  end

  def update
    Spree::Config.set(params[:preferences])
    
    respond_to do |format|
      format.html {
        redirect_to admin_openbravo_settings_path
      }
    end
  end

end
