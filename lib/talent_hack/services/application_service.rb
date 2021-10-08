# frozen_string_literal: true

require 'active_support/core_ext/string'

module TalentHack
  module Services
    class ApplicationService
      class << self
        def no_modulize
          @no_modulize = true
        end

        def modulize(*mods)
          return if @no_modulize

          (mods.length > 0 ? mods : modules).each do |mod|
            self.send(:include, "::TalentHack::Helpers::#{mod.to_s.camelcase}".constantize)
          end
        end

        def modules
          @modules ||= %w[memoizable validatable]
        end
      end
    end
  end
end
