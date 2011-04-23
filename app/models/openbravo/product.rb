module Openbravo
#  Usage example:
# 
#  product  = Openbravo::Product.find("8A64B71A2B0B2946012B0BC436170107").attributes["Product"]
#  products = Openbravo::Product.all(:params => {:maxResult => 3})
#  product  = Openbravo::Product.new(:name => "RoR-Mug", :product_category => "Ruby on Rails", :searchKey => "ROR-101")
#
  class Product < Base
    self.element_name = "Product"
    self.collection_name = "Product"
    validates :name, :searchKey, :product_category_id, :presence => true

    def product_category_id
      return nil unless self.product_category
      cat = Openbravo::ProductCategory.last(:params => {:where => "searchKey='#{self.product_category}'"})
      return cat.id if cat.present?
      ProductCategory.create(:name => self.product_category)
      Openbravo::ProductCategory.last(:params => {:where => "searchKey='#{self.product_category}'"}).id
    end

    def to_xml(options={})
      product_category_id = self.product_category_id
      self.attributes.delete(:product_category)
      
      super(options) do |xml|
        xml.productCategory nil, 'id' => product_category_id
        xml.organization    nil, 'id' => Spree::Openbravo::Config[:organization_id]
        xml.taxCategory     nil, 'id' => Spree::Openbravo::Config[:tax_category_id]
        xml.uOM             nil, 'id' => '100' # Unit
        xml.productType "I" # Item
        # xml.searchKey "ROR-101" should be unique for each product
      end
    end
  end
end
