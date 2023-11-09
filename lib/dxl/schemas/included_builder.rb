# frozen_string_literal: true

module DXL
  module Schemas
    class IncludedBuilder
      def initialize(serializer, klass, included)
        @serializer = serializer
        @klass = klass
        @included = included
      end

      def call
        data
      end

      private

      def data
        {
          type: :array,
          items: {
            anyOf: items
          }
        }
      end

      def items
        @included.map do |relationship|
          relationship_value = @serializer.relationships_to_serialize[relationship]
          klass = fetch_klass(relationship_value)
          ::DXL::Schemas::AttributesBuilder.new(relationship_value.serializer, klass.constantize, 1).call
        end
      end

      def fetch_klass(relationship_value)
        @klass.
          reflect_on_all_associations.
          find { |association| association.name == relationship_value.object_method_name }.
          class_name
      end
    end
  end
end
