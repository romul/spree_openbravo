module Openbravo
  class Order < Base
    self.element_name = "Order"
    self.collection_name = "Order"
    attr_accessor :business_partner_id, :partner_address_id
    
    def self.create(order)
      return false if Openbravo::Order.first(:params => {:where => "documentNo='#{order.number}'"})
      attributes = {
          :documentNo => order.number, 
          :orderDate  => order.completed_at.strftime("%Y-%m-%dT00:00:00.0Z"),
          :summedLineAmount => order.item_total.to_s,
          :grandTotalAmount => order.total.to_s,
      }
      record = Openbravo::Order.new(attributes)
      record.business_partner_id = Openbravo::User.create(order.user).id
      record.partner_address_id  = Openbravo::BusinessPartnerLocation.create(order).id
      res = record.save
      order.line_items.each {|li| Openbravo::OrderLine.create(li) }
      res
    end
    
    def to_xml(options={})
      price_list_version = Openbravo::PriceList.find(Spree::Openbravo::Config[:price_list_id])
      price_list_id = price_list_version.attributes['PricingPriceListVersion'].priceList.id
      
      super(options) do |xml|
        xml.organization nil, 'id' => Spree::Openbravo::Config[:organization_id]
        xml.paymentTerms nil, 'id' => Spree::Openbravo::Config[:payment_term_id]
        xml.priceList nil, 'id' => price_list_id
        xml.documentType nil, 'id' => Spree::Openbravo::Config[:order_transaction_document_id]
        xml.transactionDocument nil, 'id' => Spree::Openbravo::Config[:order_transaction_document_id]
        xml.businessPartner  nil, :id => self.business_partner_id
        xml.partnerAddress nil, :id => self.partner_address_id
        xml.currency nil, :id => Spree::Openbravo::Config[:currency_id]
        xml.warehouse nil, :id => Spree::Openbravo::Config[:warehouse_id]
        
        xml.accountingDate self.orderDate
        xml.salesTransaction true
      end
    end
  end
end
