# frozen_string_literal: true

module DXL
  module Schemas
    class AttributesBuilder
      def initialize(serializer, klass, relationships:)
        @serializer = serializer
        @klass = klass
        @relationships = relationships
      end

      def call
        return single_data unless is_array?
        array_data
      end

      private

      def attribute_types
        @attribute_types ||= Array(@klass).first.attribute_types
      end

      def is_array?
        @klass.is_a?(Array)
      end

      def single_data
        {
          type: :object,
          properties: {
            id: { type: :string, default: '0' },
            type: { type: :string, default: Array(@klass).first.name.demodulize.camelize(:lower) },
            attributes: {
              type: :object,
              properties: properties
            }
          }.tap do |whitelist|
            whitelist[:relationships] = {
              type: :object,
              properties: relationships
            } if @relationships.present?
          end
        }
      end

      def array_data
        {
          type: :array,
          items: single_data
        }
      end

      def properties
        @serializer.attributes_to_serialize.each_with_object({}) do |(key, value), hash|
          hash[key] = column(value)
          hash
        end
      end

      def column(value)
        return build_column(value.method) if column_types[value.method].present?
        default_column
      end

      def build_column(method)
        if column_types[method] == :json && attribute_types[method.to_s].instance_variable_get("@model_klass")
          return ::DXL::Schemas::SerializedBuilder.new(@klass, method).call
        end

        if column_types[method] == :array && attribute_types[method.to_s].instance_variable_get("@model_klass")
          return {
            type: :array,
            items: ::DXL::Schemas::SerializedBuilder.new(@klass, method).call
          }
        end

        {
          type: cast_type(method),
          nullable: true,
        }.tap do |whitelist|
          whitelist[:format] = format_types[column_types[method]] if format_types[column_types[method]].present?
        end
      end

      def default_column
        {
          anyOf: [
            { type: :string, nullable: true },
            { type: :integer, nullable: true },
            { type: :boolean, nullable: true },
            { type: :array, nullable: true },
            { type: :number, nullable: true },
            { type: :object, nullable: true },
          ]
        }
      end

      def column_types
        @column_types ||= attribute_types.each_with_object({}) do |(key, value), hash|
          hash[key.to_sym] = value.type
          hash
        end
      end

      def cast_type(method)
        return to_enum(method) if is_enum?(method)

        {
          text: :string,
          date: :string,
          datetime: :string,
          float: :number,
          decimal: :number,
          jsonb: :number,
        }[column_types[method]] || column_types[method]
      end

      def is_enum?(method)
        Array(@klass).first.defined_enums[method.to_s].present?
      end

      def to_enum(_method)
        :string
      end

      def format_types
        {
          date: :date,
          datetime: :'date-time',
          float: :double,
          decimal: :double,
        }
      end

      def relationships
        ::DXL::Schemas::RelationshipsBuilder.new(@serializer, relationships: @relationships).call
      end
    end
  end
end
