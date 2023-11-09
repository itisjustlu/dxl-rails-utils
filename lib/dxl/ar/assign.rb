# frozen_string_literal: true

require 'dxl/services/application_service'

module DXL
  module AR
    class Assign < ::DXL::Services::ApplicationService
      behave_as :interactor
      delegate_to_context :object_class, :opts, :key

      def call = context.send("#{key}=", instance)

      private

      def instance = object_class.new(opts)
    end
  end
end
