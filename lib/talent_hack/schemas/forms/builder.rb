# frozen_string_literal: true

module TalentHack
  module Schemas
    module Forms
      class Builder
        def self.properties(args)
          const_set('PROPERTIES', args)
        end

        def call
          "#{self.class}::PROPERTIES".constantize.each_with_object({}) do |(key, value), hash|
            hash[key] = { type: value }
            hash
          end
        end
      end
    end
  end
end
