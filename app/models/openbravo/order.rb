module Openbravo
  class Order < Base
    self.element_name = "Order"
    self.collection_name = "Order"
    attr_accessor :business_partner_id, :partner_address_id, :bill_address_id, :payment_method_id
    
    def self.create(order)
      return false if !order.completed?
      return false if Openbravo::Order.first(:params => {:where => "documentNo='#{order.number}'"})
      attributes = {
          :documentNo => order.number, 
          :orderDate  => order.completed_at.strftime("%Y-%m-%dT00:00:00.0Z"),
          :summedLineAmount => order.item_total.to_s,
          :grandTotalAmount => order.total.to_s,
      }
      record = Openbravo::Order.new(attributes)
      record.business_partner_id = Openbravo::User.create(order.user).id
      record.partner_address_id  = Openbravo::BusinessPartnerLocation.create(order.ship_address, order.user_id).id
      record.bill_address_id = Openbravo::BusinessPartnerLocation.create(order.bill_address, order.user_id).id
      payment_method = Openbravo::PaymentMethod.first(:params => {:where => "name='#{order.payment_method.name}'"})
      if payment_method
        record.payment_method_id = payment_method.id
      end
      res = record.save
      order.line_items.each {|li| Openbravo::OrderLine.create(li) }
      create_adjustments(order)
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
        xml.businessPartner nil, :id => self.business_partner_id
        xml.partnerAddress nil, :id => self.partner_address_id
        xml.deliveryLocation nil, :id => self.partner_address_id
        xml.invoiceAddress nil, :id => self.bill_address_id
        xml.paymentMethod(nil, :id => self.payment_method_id) if self.payment_method_id
        xml.currency nil, :id => Spree::Openbravo::Config[:currency_id]
        xml.warehouse nil, :id => Spree::Openbravo::Config[:warehouse_id]
        
        xml.accountingDate self.orderDate
        xml.salesTransaction true
      end
    end
    
    private
    
    def self.create_adjustments(order)
      order.adjustments.shipping.each{|adjustment| Openbravo::OrderLine.create_for_adjustment(adjustment)}
      order.promotion_credits.each{|creadit| Openbravo::OrderLine.create_for_adjustment(credit)}
    end
  end
end
