require 'pathname'
require 'foreman/export'

module Foreman
  module Export
    class FanfareRunit < Base
      def export
        error("Must specify a location") unless location

        engine.procfile.entries.each do |process|
          Service.new("#{app}-#{process.name}-1", process.command)
        end
      end
    end
  end
end
