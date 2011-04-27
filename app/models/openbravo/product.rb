module Openbravo
#  Usage example:
# 
#  product  = Openbravo::Product.find("8A64B71A2B0B2946012B0BC436170107").attributes["Product"]
#  products = Openbravo::Product.all(:params => {:maxResult => 3})
#  Openbravo::Product.create(Product.first)
#
  class Product < Base
    self.element_name = "Product"
    self.collection_name = "Product"
    attr_accessor :product_category_id
    validates :name, :searchKey, :product_category_id, :presence => true

    def self.create(product)
      record = self.new(:name => product.name, :searchKey => "SP/#{product.permalink}")
      product_category = product.taxons.first.try(:name) || "Spree"
      cat = Openbravo::ProductCategory.last(:params => {:where => "searchKey='#{product_category}'"})
      if cat.blank?
        ProductCategory.create(:name => product_category)
        cat = Openbravo::ProductCategory.last(:params => {:where => "searchKey='#{product_category}'"})
      end
      record.product_category_id = cat.id
      res = record.save
      Openbravo::Price.create(:product_search_key => "SP/#{product.permalink}", :standardPrice => product.cost_price || product.price, :listPrice => product.price)
      res
    end

    def to_xml(options={})
      super(options) do |xml|
        xml.productCategory nil, 'id' => self.product_category_id
        xml.organization    nil, 'id' => Spree::Openbravo::Config[:organization_id]
        xml.taxCategory     nil, 'id' => Spree::Openbravo::Config[:tax_category_id]
        xml.uOM             nil, 'id' => '100' # Unit
        xml.productType "I" # Item
      end
    end
  end
end
