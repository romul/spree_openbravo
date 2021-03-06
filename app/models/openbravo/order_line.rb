module Openbravo
  class OrderLine < Base
    self.element_name = self.collection_name = "OrderLine"
    
    def self.create(line_item)
      order = Openbravo::Order.last(:params => {:where => "documentNo='#{line_item.order.number}'"})
      Openbravo::Product.create(line_item.variant.product)
      product = Openbravo::Product.last(:params => {:where => "searchKey='#{line_item.variant.product.search_key}'"})
      
      attributes = {
          :order_id => order.id,
          :product_id => product.id,
          :orderedQuantity => line_item.quantity,
          :reservedQuantity => line_item.quantity,
          :deliveredQuantity => '0',
          :invoicedQuantity => line_item.quantity,
          :unitPrice => line_item.price,
          :listPrice => line_item.variant.price,
          :description => line_item.variant.options_text,
          :orderDate => line_item.order.completed_at.strftime("%Y-%m-%dT00:00:00.0Z"),
      }
      super(attributes)
    end
    
    def self.create_for_adjustment(adjustment)
      order = Openbravo::Order.last(:params => {:where => "documentNo='#{adjustment.order.number}'"})
      product_name = adjustment.source_type
      product = Openbravo::Product.find_or_create_by_hash(:name => product_name, :searchKey => "Spree/#{product_name}")     
      attributes = {
          :order_id => order.id,
          :product_id => product.id,
          :orderedQuantity => 1,
          :reservedQuantity => 0,
          :deliveredQuantity => 0,
          :invoicedQuantity => 1,
          :unitPrice => adjustment.amount,
          :listPrice => adjustment.amount,
          :description => adjustment.label,
          :orderDate => adjustment.order.completed_at.strftime("%Y-%m-%dT00:00:00.0Z"),
      }
      Openbravo::OrderLine.new(attributes).save
    end
    
    def to_xml(options={})
      order_id = self.attributes.delete(:order_id)
      product_id = self.attributes.delete(:product_id)
      
      super(options) do |xml|
        xml.product nil, 'id' => product_id
        xml.salesOrder nil, 'id' => order_id
        xml.warehouse nil, :id => Spree::Openbravo::Config[:warehouse_id]
        xml.currency nil, :id => Spree::Openbravo::Config[:currency_id]
        xml.uOM nil, 'id' => '100' # Unit
        xml.tax nil, 'id' => Spree::Openbravo::Config[:tax_rate_id]
        xml.priceLimit((2*self.listPrice.to_f/3).round(2))
        xml.lineNetAmount(self.orderedQuantity * self.unitPrice)
        xml.lineNo '1'
        xml.freightAmount '0'
      end
    end
  end
end
