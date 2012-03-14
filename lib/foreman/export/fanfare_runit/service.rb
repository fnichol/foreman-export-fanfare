module Foreman
  module Export
    module FanfareRunit
      class Service
        attr_reader :name, :command, :service_root_path, :environment

        def initialize(name, command, service_root_path, environment)
          @name               = name
          @command            = command
          @service_root_path  = service_root_path
          @environment        = environment
        end
      end
    end
  end
end
