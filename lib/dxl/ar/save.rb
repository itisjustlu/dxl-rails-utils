# frozen_string_literal: true

require 'dxl/services/application_service'
require 'dxl/errors/ar/save_error'

module DXL
  module AR
    class Save < ::DXL::Services::ApplicationService
      behave_as :interactor
      error_class ::DXL::Errors::AR::SaveError
      delegate_to_context :key

      def call
        instance = context.send(key)

        unless instance.save
          context.fail!(
            message: instance.errors.full_messages.to_sentence,
          )
        end
      end
    end
  end
end
