CheckoutController.class_eval do
  private
  def after_complete_with_openbravo
    after_complete_without_openbravo
    if defined? Delayed::Job 
      Openbravo::Order.delay.create(@order)
    else
      Openbravo::Order.create(@order)
    end
  end
  alias_method_chain :after_complete, :openbravo
end
