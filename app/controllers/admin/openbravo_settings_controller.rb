class Admin::OpenbravoSettingsController < Admin::BaseController

  def edit
    @organizations = Rails.cache.fetch('openbravo-organizations-list') do
      Openbravo::Organization.all.map{|org| [org.identifier, org.id] }
    end
    
    @tax_categories = Rails.cache.fetch('openbravo-tax-categories') do
      Openbravo::TaxCategory.all.map{|cat| [cat.name, cat.id] }
    end
    
    @price_lists = Rails.cache.fetch('openbravo-price-lists') do
      Openbravo::PriceList.all.map{|list| [list.name, list.id] }
    end
    
    @bp_categories = Rails.cache.fetch('openbravo-bp-categories') do
      Openbravo::BusinessPartnerCategory.all.map{|cat| [cat.name, cat.id] }
    end
    
    @order_transaction_documents = Rails.cache.fetch('openbravo-order-transaction-documents') do
      Openbravo::DocumentType.all(:params => {:where => "documentCategory='SOO'"}).map{|doc| [doc.name, doc.id] }
    end
    
    @payment_terms = Openbravo::PaymentTerm.all.map{|term| [term.name, term.id] }
  end

  def update
    Spree::Openbravo::Config.set(params[:preferences])
    
    respond_to do |format|
      format.html {
        redirect_to admin_openbravo_settings_path
      }
    end
  end

end
