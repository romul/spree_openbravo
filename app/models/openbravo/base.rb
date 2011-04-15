class Openbravo::Base < ActiveResource::Base
  # default auth data
  self.site = Spree::Openbravo::Config[:url]
  self.user = Spree::Openbravo::Config[:user]
  self.password = Spree::Openbravo::Config[:password]

  class << self 
    # override method to avoid .xml in URL
    def element_path(id, prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}/#{URI.escape id.to_s}#{query_string(query_options)}"
    end

    # override method to avoid .xml in URL
    def collection_path(prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
    end
    
    protected
    
    def instantiate_collection(collection, prefix_options = {})
      collection[self.collection_name].collect! { |record| instantiate_record(record, prefix_options) }
    end
  end
end
