module Openbravo
  class User < Base
    self.element_name = "BusinessPartner"
    self.collection_name = "BusinessPartner"
    validates :name, :searchKey, :presence => true
    
    def self.create(user)
      record = self.new(:searchKey => "SU/#{user.id}", :name => user.email)
      record.save
      Openbravo::User.first(:params => {:where => "searchKey='SU/#{user.id}'"})
    end
    
    def to_xml(options={})
      super(options) do |xml|
        xml.organization nil, 'id' => Spree::Openbravo::Config[:organization_id]
        xml.businessPartnerCategory nil, 'id' => Spree::Openbravo::Config[:customer_category_id]
      end
    end
  end
end
