class OpenbravoConfiguration < Configuration
  preference :url, :string, :default => "http://192.168.0.100/openbravo/ws/dal/"
  preference :user, :string, :default => "Openbravo"
  preference :password, :password, :default => "openbravo"
end
