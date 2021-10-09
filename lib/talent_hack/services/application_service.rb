# frozen_string_literal: true

require 'active_support/core_ext/string'

module TalentHack
  module Services
    class ApplicationService
      class << self
        def no_modules
          @no_modules = true
        end

        def use(*mods)
          return if @no_modules

          (mods.length > 0 ? mods : modules).each do |mod|
            self.send(:include, "::TalentHack::Helpers::#{mod.to_s.camelcase}Helper".constantize)
          end
        end

        def modules
          @modules ||= %i[client interactor memoize validator]
        end
      end
    end
  end
end
