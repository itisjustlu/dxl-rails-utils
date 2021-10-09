# frozen_string_literal: true

require 'active_support/core_ext/string'

module TalentHack
  module Helpers
    module ValidatorHelper
      ERROR_CLASS = TalentHack::Errors::ApplicationError
      VALIDATOR_CLASS = nil

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

        def validator_class(klass)
          const_set("VALIDATOR_CLASS", klass)
        end
      end

      module InstanceMethods
        def validate(object)
          ::TalentHack::Services::Validator
            .new(object, {
              validator_class: "#{self.class}::VALIDATOR_CLASS".constantize,
              error_class: "#{self.class}::ERROR_CLASS".constantize
            })
            .call
        end
      end
    end
  end
end
