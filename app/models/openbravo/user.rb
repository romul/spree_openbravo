module Openbravo
#  Usage example:
# 
# Openbravo::User.create(:searchKey => "SU/#{@user.id}", :name => @user.email)
#
  class User < Base
    self.element_name = "BusinessPartner"
    self.collection_name = "BusinessPartner"
    validates :name, :searchKey, :presence => true
    
    def to_xml(options={})
      super(options) do |xml|
        xml.organization nil, 'id' => Spree::Openbravo::Config[:organization_id]
        xml.businessPartnerCategory nil, 'id' => Spree::Openbravo::Config[:customer_category_id]
      end
    end
  end
end
