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
      return false if Openbravo::Product.last(:params => {:where => "searchKey='#{product.search_key}'"})
      record = self.new(:name => product.name, :searchKey => product.search_key)
      product_category = product.taxons.first.try(:name) || "Spree"
      cat = ProductCategory.create(:name => product_category, :searchKey => product_category)
      record.product_category_id = cat.id
      res = record.save
      Openbravo::Price.create(:product_search_key => product.search_key, :standardPrice => product.cost_price || product.price, :listPrice => product.price)
      res
    end
    
    def self.find_or_create_by_hash(options)
      p = Openbravo::Product.last(:params => {:where => "searchKey='#{options[:searchKey]}'"})
      return p if p
      cat = Openbravo::ProductCategory.create(:name => "Spree", :searchKey => "Spree")
      record = Openbravo::Product.new(options)
      record.product_category_id = cat.id
      record.save
      Openbravo::Product.last(:params => {:where => "searchKey='#{options[:searchKey]}'"})
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
