require 'rails/generators/active_record'

module Felon
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      # ActiveRecord::Generators::Base inherits from Rails::Generators::NamedBase which 
      # requires a NAME parameter for the new table name. Our generator always uses 
      # fixed names, so we just set a random name here.
      argument :name, type: :string, default: 'random_name'

      desc "Generates a migration to install required Felon tables"
      source_root File.expand_path('../templates', __FILE__)

      def install
        migration_template "felon_install.rb", "db/migrate/felon_install.rb"
      end
    end
  end
end
