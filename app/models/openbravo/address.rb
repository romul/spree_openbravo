module Openbravo
  class Address < Base
    self.element_name = "Location"
    self.collection_name = "Location"
    validates :addressLine1, :cityName, :postalCode, :presence => true
    attr_accessor :country_id, :region_id
    
    def self.create(address)
      address_line1 = address.address1.gsub("'", "`")
      address_line2 = address.address2.gsub("'", "`")
      attributes = {
          :addressLine1 => address_line1, 
          :addressLine2 => address_line2,
          :cityName     => address.city,
          :postalCode   => address.zipcode,
      }
      record = self.new(attributes)
      country = Openbravo::Country.last(:params => {:where => "iSOCountryCode='#{address.country.iso}'"})
      record.country_id = country.id
      region = Openbravo::Region.last(:params => {:where => "name='#{address.state.abbr}'"})
      record.region_id = region.id
      record.save
      Openbravo::Address.last(:params => {:where => "addressLine1='#{address_line1}'"})
    end
    
    def to_xml(options={})
      super(options) do |xml|
        xml.country nil, :id => self.country_id
        xml.region  nil, :id => self.region_id
      end
    end
  end
end
