require 'pathname'
require 'foreman/export'

module Foreman
  module Export
    class FanfareRunit < Base
      def export
        error("Must specify a location") unless location

        @location = Pathname.new(@location)

        engine.procfile.entries.each do |process|
          1.upto(self.concurrency[process.name]) do |num|
            service_name  = "#{app}-#{process.name}-#{num}"
            port          = engine.port_for(process, num, self.port)
            env           = { 'PORT' => port }.merge(engine.environment)

            service = Service.new(service_name, process.command, location, env)
            service.create!
            service.activate!
          end
        end
      end
    end
  end
end
