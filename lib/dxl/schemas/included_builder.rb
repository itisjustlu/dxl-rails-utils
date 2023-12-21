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
          items = relationship.to_s.split('.')
          last_relationship = items.last.to_sym

          new_serializer = @serializer
          new_klass = Array(@klass).first

          if items.size > 1
            items.pop
            items.each do |item|
              new_serializer = new_serializer.relationships_to_serialize[item.to_sym].serializer
              new_klass = new_klass.
                reflect_on_all_associations.
                find { |association| association.name == item.to_sym }.
                class_name.
                constantize
            end
          end


          relationship_value = new_serializer.relationships_to_serialize[last_relationship]
          klass = fetch_klass(new_klass, relationship_value)
          ::DXL::Schemas::AttributesBuilder.new(relationship_value.serializer, klass.constantize, 1).call
        end
      end

      def fetch_klass(new_klass, relationship_value)
        Array(new_klass).
          first.
          reflect_on_all_associations.
          find { |association| association.name == relationship_value.object_method_name }.
          class_name
      end
    end
  end
end
