module Openbravo
#  Usage example:
# 
# Openbravo::Price.create(:product_search_key => "ROR-101", :standardPrice => 5, :listPrice => 9.99)
#
  class Price < Base
    self.element_name = "PricingProductPrice"
    self.collection_name = "PricingProductPrice"
    validates :standardPrice, :listPrice, :product_search_key, :presence => true
    
    def encode(options={})
      search_key = self.attributes.delete(:product_search_key)
      product = Openbravo::Product.all(:params => {:where => "searchKey='#{search_key}'"})
      xml_str = to_xml(:skip_instruct => true) do |xml|
        xml.product nil, 'id' => product.id
        xml.priceListVersion nil, 'id' => Spree::Openbravo::Config[:price_list_id]
        xml.priceLimit((2*self.listPrice.to_f/3).round(2))
      end

      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
      "<ob:Openbravo xmlns:ob=\"http://www.openbravo.com\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n" +
      xml_str +
      "</ob:Openbravo>"
    end
  end
end
