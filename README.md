Spree Openbravo Connector
==============




Installation
============

1. Install Openbravo appliance on VirtualBox like described [here](http://wiki.openbravo.com/wiki/Virtual_appliances#VirtualBox_appliance_2)
2. Install extension spree_openbravo:
   2.1. In Gemfile add `gem "spree_openbravo", :git => "git://github.com/romul/spree_openbravo.git"`
   2.2. bundle install
3. Run a virtual machine with Openbravo
4. Set the [connection settings](https://github.com/romul/spree_openbravo/blob/master/lib/openbravo_configuration.rb#L2..L4) for Openbravo in the site extension, if they differ from the default settings.
5. Go to localhost:3000/admin/openbravo_settings/edit and set the remaining settings.


Copyright (c) 2011 Roman Smirnov, released under the New BSD License
