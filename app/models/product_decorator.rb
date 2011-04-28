Product.class_eval do
  def search_key
    "SP/#{self.permalink}"
  end
end
