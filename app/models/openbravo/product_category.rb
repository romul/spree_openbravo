module Openbravo
  class ProductCategory < Base
    self.element_name = "ProductCategory"
    self.collection_name = "ProductCategory"
    validates :name, :presence => true
    
    def encode(options={})
      xml_str = to_xml(:skip_instruct => true) do |xml|
        xml.organization nil, 'id' => Spree::Openbravo::Config[:organization_id]
        xml.searchKey self.name
        xml.plannedMargin '0' # I don't know why.. but this field is required
      end

      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
      "<ob:Openbravo xmlns:ob=\"http://www.openbravo.com\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n" +
      xml_str +
      "</ob:Openbravo>"
    end
  end
end
