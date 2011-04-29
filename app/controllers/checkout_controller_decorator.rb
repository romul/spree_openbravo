CheckoutController.class_eval do
  private
  def after_complete_with_openbravo
    after_complete_without_openbravo
    # TODO: move to Delayed::Job
    Openbravo::Order.create(@order)
  end
  alias_method_chain :after_complete, :openbravo
end
