# frozen_string_literal: true

require 'dxl/structs/application_struct_array'

module DXL
  module Schemas
    class SerializedBuilder
      def initialize(klass, method)
        @klass = klass
        @method = method
      end

      def call
        {
          type: :object,
          properties: properties
        }
      end

      private

      def data_klass
        @data_klass ||= Array(@klass).first.serialized_attributes[@method.to_sym]
      end

      def properties
        return properties_object unless data_klass < ::DXL::Structs::ApplicationStructArray

        {
          type: :array,
          items: properties_object
        }
      end

      def properties_object
        data_klass.schema.keys.each_with_object({}).each do |key, hash|
          hash[key.name] = {
            type: type_mapper[key.type.name],
            nullable: true
          }.tap do |attr|
            attr[:enum] = (key.mapping.keys << nil) if key.respond_to?(:mapping)
          end
          hash
        end
      end

      def type_mapper
        {
          "String" => :string,
          "NilClass | String" => :string,
          "NilClass | Integer" => :integer,
          "NilClass | TrueClass | FalseClass" => :boolean,
        }
      end
    end
  end
end
