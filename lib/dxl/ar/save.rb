# frozen_string_literal: true

require 'dxl/services/application_service'

module DXL
  module AR
    class Save < ::DXL::Services::ApplicationService
      behave_as :interactor
      delegate_to_context :key

      def call
        instance = context.send(key)

        unless instance.save
          context.fail!(
            message: instance.errors.full_messages.to_sentence,
            status: 422,
          )
        end
      end
    end
  end
end
