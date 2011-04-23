module Openbravo
  class ProductCategory < Base
    self.element_name = "ProductCategory"
    self.collection_name = "ProductCategory"
    validates :name, :presence => true
    
    def to_xml(options={})
      super(options) do |xml|
        xml.organization nil, 'id' => Spree::Openbravo::Config[:organization_id]
        xml.searchKey self.name
        xml.plannedMargin '0' # I don't know why.. but this field is required
      end
    end
  end
end
