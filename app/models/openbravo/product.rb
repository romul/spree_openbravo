module Openbravo
#  Usage example:
# 
#  product  = Openbravo::Product.find("8A64B71A2B0B2946012B0BC436170107").attributes["Product"]
#  products = Openbravo::Product.all(:params => {:maxResult => 3})
#
  class Product < Base
    self.element_name = "Product"
    self.collection_name = "Product"

    def encode(options={})
      xml_str = to_xml(:skip_instruct => true) do |xml|
        xml.productCategory nil, 'id' => "8A64B71A2B0B2946012B0BB9547C008E" # taxon
        xml.organization    nil, 'id' => "B9C7088AB859483A9B1FB342AC2BE17A"
        xml.taxCategory     nil, 'id' => "9C17076DA7754B7AA7ED1803CCC9EC4E"
        xml.uOM             nil, 'id' => '100' # Unit
        xml.productType "I" # Item
        # xml.searchKey "ROR-101" should be unique for each product
      end
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
      "<ob:Openbravo xmlns:ob=\"http://www.openbravo.com\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n" +
      xml_str +
      "</ob:Openbravo>"
    end    
    
  end
end
