# frozen_string_literal: true

module DXL
  module Schemas
    module Forms
      class Builder
        def self.properties(args)
          const_set('PROPERTIES', args)
        end

        def call
          "#{self.class}::PROPERTIES".constantize.each_with_object({}) do |(key, value), hash|
            hash[key] = if value.respond_to?(:call)
              value.call(@klass)
            else
              { type: value }
            end

            hash
          end
        end
      end
    end
  end
end
