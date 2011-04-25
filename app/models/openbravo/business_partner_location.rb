module Openbravo
  class BusinessPartnerLocation < Base
    self.element_name = self.collection_name = "BusinessPartnerLocation"
    
    def self.create(order)
      response = super(:location_address_id => Openbravo::Address.create(order.ship_address).id,
            :business_partner_id => Openbravo::User.first(:params => {:where => "searchKey = 'SU/#{order.user.id}'"}).id)
      result = case response.log[/\w+/]
        when "Updated":  response.updated
        when "Inserted": response.inserted
      end
      result.attributes[element_name]
    end
    
    def to_xml(options={})
      business_partner_id = attributes.delete(:business_partner_id)
      location_address_id = attributes.delete(:location_address_id)
      super(options) do |xml|
        xml.organization nil, 'id' => Spree::Openbravo::Config[:organization_id]
        xml.businessPartner nil, :id => business_partner_id
        xml.locationAddress nil, :id => location_address_id
      end
    end
  end
end
