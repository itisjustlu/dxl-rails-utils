# frozen_string_literal: true

require 'active_support/core_ext/string'

module TalentHack
  module Services
    class ApplicationService
      class << self
        def behave_as(*mods)
          mods.flatten.each do |mod|
            self.send(:include, "::TalentHack::Modules::#{mod.to_s.camelcase}Module".constantize)
          end
        end
      end
    end
  end
end
