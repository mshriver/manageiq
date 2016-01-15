module ManageIQ::Providers
  module AnsibleTower
    class ConfigurationManager::Refresher < ManageIQ::Providers::BaseManager::Refresher
      include ::EmsRefresh::Refreshers::EmsRefresherMixin

      def parse_inventory(manager, _targets)
        manager.with_provider_connection do |connection|
          manager.api_version = connection.version
          manager.save

          raw_ems_data = {:hosts => connection.api.hosts.all}
          ConfigurationManager::RefreshParser.configuration_inv_to_hashes(raw_ems_data)
        end
      end

      def save_inventory(manager, targets, hashes)
        EmsRefresh.save_configuration_manager_inventory(manager, hashes, targets[0])
      end
    end
  end
end
