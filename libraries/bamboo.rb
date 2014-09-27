# Chef class
class Chef
  # Chef::Recipe class
  class Recipe
    # Chef::Recipe::Bamboo class
    class Bamboo
      def self.settings(node)
        begin
          if Chef::Config[:solo]
            begin
              settings = Chef::DataBagItem.load('bamboo', 'bamboo')['local']
            rescue
              Chef::Log.info('No bamboo data bag found')
            end
          else
            begin
              settings = Chef::EncryptedDataBagItem.load('bamboo', 'bamboo')[node.chef_environment]
            rescue
              Chef::Log.info('No bamboo encrypted data bag found')
            end
          end
        ensure
          settings ||= node['bamboo']
          settings['database']['port'] ||= default_database_port settings['database']['type']
          settings['database']['testInterval'] ||= 2
        end

        settings
      end

      def default_database_port(type)
        case type
        when 'mysql'
          3306
        when 'postgresql'
          5432
        when 'sqlserver'
          1433
        else
          Chef::Log.warn("Unsupported database type (#{type}) in Bamboo cookbook.")
          Chef::Log.warn('Please add to Bamboo cookbook or hard set Bamboo database port.')
          nil
        end
      end
    end
  end
end
