# frozen_string_literal: true

require 'active_support/core_ext/string'
require 'dxl/errors/application_error'

module DXL
  module Modules
    module ValidatorModule
      ERROR_CLASS = DXL::Errors::ApplicationError

      def self.included(base)
        base.class_eval do
          extend ClassMethods
          include InstanceMethods
        end
      end

      module ClassMethods
        def error_class(klass)
          const_set("ERROR_CLASS", klass)
        end
      end

      module InstanceMethods
        def validate(object, attributes: nil, validator_class: nil)
          ::DXL::Services::Validator
            .new(object, {
              attributes: attributes,
              validator_class: validator_class,
              error_class: "#{self.class}::ERROR_CLASS".constantize
            })
            .call
        end
      end
    end
  end
end
