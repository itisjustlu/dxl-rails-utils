# frozen_string_literal: true

module DXL
  module Schemas
    class Builder
      def initialize(serializer, klass, included: nil)
        @serializer = serializer
        @klass = klass
        @included = included
        @phase = 0
      end

      def call
        {
          type: :object,
          properties: {
            data: data
          }.tap do |whitelist|
            whitelist[:included] = included if @included.present?
          end
        }
      end

      private

      def data
        ::DXL::Schemas::AttributesBuilder.new(@serializer, @klass, @phase).call
      end

      def included
        ::DXL::Schemas::IncludedBuilder.new(@serializer, @klass, @included).call
      end
    end
  end
end
