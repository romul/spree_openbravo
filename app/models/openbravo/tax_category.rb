module Openbravo
  class TaxCategory < Base
    self.element_name = "FinancialMgmtTaxCategory"
    self.collection_name = "FinancialMgmtTaxCategory"
    validates :name, :presence => true
    
    def to_xml(options={})
      super(options) do |xml|
        xml.organization nil, 'id' => Spree::Openbravo::Config[:organization_id]
      end
    end
  end
end
