# frozen_string_literal: true

require 'store_model'

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
        @data_klass ||= Array(@klass).first.attribute_types[@method.to_s].instance_variable_get("@model_klass")
      end

      def properties
        data_klass.attribute_types.each_with_object({}) do |(key, value), hash|
          if value.type == :json
            hash[key.to_sym] = ::DXL::Schemas::SerializedBuilder.new(data_klass, key).call
          elsif value.type == :array
            hash[key.to_sym] = {
              type: :array,
              items: ::DXL::Schemas::SerializedBuilder.new(data_klass, key).call
            }
          else
            hash[key.to_sym] = { type: value.type, nullable: true }
            hash
          end
        end
      end
    end
  end
end
