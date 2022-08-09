# frozen_string_literal: true

module DXL
  module Schemas
    class IncludedBuilder
      def initialize(serializer, relationships)
        @serializer = serializer
        @relationships = relationships
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
        @relationships.map do |relationship|
          relationship_value = @serializer.relationships_to_serialize[relationship]
          klass = fetch_klass(relationship_value)
          ::DXL::Schemas::AttributesBuilder.new(relationship_value.serializer, klass.constantize, relationships: nil).call
        end
      end

      def fetch_klass(relationship_value)
        relationship_value.serializer.to_s.gsub('Serializer', '')
      end
    end
  end
end
