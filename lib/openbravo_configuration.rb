class OpenbravoConfiguration < Configuration
  preference :url, :string, :default => "http://192.168.0.100/openbravo/ws/dal/"
  preference :user, :string, :default => "Openbravo"
  preference :password, :password, :default => "openbravo"
  
  preference :organization_id, :string, :default => "0"
  # NOTE: taxCategory belongs to organization, so you should select taxCategory related to organization, selected above
  preference :tax_category_id, :string
end
