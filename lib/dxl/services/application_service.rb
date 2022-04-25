# frozen_string_literal: true

require 'active_support/core_ext/string'

module DXL
  module Services
    class ApplicationService
      class << self
        def behave_as(*mods)
          mods.flatten.each do |mod|
            self.send(:include, "::DXL::Modules::#{mod.to_s.camelcase}Module".constantize)
          end
        end
      end
    end
  end
end
