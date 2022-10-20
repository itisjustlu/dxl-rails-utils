# frozen_string_literal: true

require 'dxl/services/application_service'

module DXL
  module AR
    class AssignAndSave < ::DXL::Services::ApplicationService
      behave_as :interactor

      organize ::DXL::AR::Assign,
               ::DXL::AR::Save
    end
  end
end
