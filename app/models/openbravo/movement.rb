module Openbravo
  class Movement < Base
    self.element_name = self.collection_name = "MaterialMgmtMaterialTransaction"
    def self.get_count_on_hand_for(ob_product_id)
      count = Rails.cache.fetch([ob_product_id, 'count_on_hand'], :expire_in => 1.hour) do
        movements = Openbravo::Movement.all(:params => {:where => "product.id='8A64B71A2B0B2946012B0BC437C40115'"})
        movements.inject(0){|quantity, m| quantity + m.movementQuantity.to_i}
      end
    end
  end
end
