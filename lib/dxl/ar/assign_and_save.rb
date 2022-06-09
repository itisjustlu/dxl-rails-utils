# frozen_string_literal: true

require 'dxl/services/application_service'
require 'dxl/errors/ar/save_error'

module DXL
  module AR
    class AssignAndSave < ::DXL::Services::ApplicationService
      behave_as :interactor
      error_class ::DXL::Errors::AR::SaveError

      organize ::DXL::AR::Assign,
               ::DXL::AR::Save
    end
  end
end
