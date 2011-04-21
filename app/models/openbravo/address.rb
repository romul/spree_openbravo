module Openbravo
  class Address < Base
    self.element_name = "Location"
    self.collection_name = "Location"
    validates :addressLine1, :cityName, :postalCode, :presence => true
    attr_accessor :country_id, :region_id
    
    def self.create(address)
      attributes = {
          :addressLine1 => address.address1, 
          :addressLine2 => address.address2,
          :cityName     => address.city,
          :postalCode   => address.zipcode,
      }
      record = self.new(attributes)
      country = Openbravo::Country.all(:params => {:where => "iSOCountryCode='#{address.country.iso}'"})
      record.country_id = country.id
      region = Openbravo::Region.all(:params => {:where => "name='#{address.state.abbr}'"})
      record.region_id = region.id
      record.save
      Openbravo::Address.last(:params => {:where => "addressLine1='#{address.address1}'"})
    end
    
    def encode(options={})
      xml_str = to_xml(:skip_instruct => true) do |xml|
        xml.country nil, :id => self.country_id
        xml.region  nil, :id => self.region_id
      end

      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
      "<ob:Openbravo xmlns:ob=\"http://www.openbravo.com\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n" +
      xml_str +
      "</ob:Openbravo>"
    end
  end
end
