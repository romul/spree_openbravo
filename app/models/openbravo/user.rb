module Openbravo
#  Usage example:
# 
# Openbravo::User.create(:searchKey => "SU/#{@user.id}", :name => @user.email)
#
  class User < Base
    self.element_name = "BusinessPartner"
    self.collection_name = "BusinessPartner"
    validates :name, :searchKey, :presence => true
    
    def encode(options={})
      xml_str = to_xml(:skip_instruct => true) do |xml|
        xml.organization nil, 'id' => Spree::Openbravo::Config[:organization_id]
        xml.businessPartnerCategory nil, 'id' => Spree::Openbravo::Config[:customer_category_id]
      end

      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
      "<ob:Openbravo xmlns:ob=\"http://www.openbravo.com\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n" +
      xml_str +
      "</ob:Openbravo>"
    end
  end
end
