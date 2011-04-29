class SpreeOpenbravoHooks < Spree::ThemeSupport::HookListener
  insert_after :admin_configurations_menu do
    "<%= configurations_menu_item(I18n.t('openbravo.settings'), admin_openbravo_settings_path, I18n.t('openbravo.manage_settings')) %>"
  end
end
