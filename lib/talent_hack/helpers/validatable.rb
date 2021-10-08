# frozen_string_literal: true

require 'active_support/core_ext/string'

module TalentHack
  module Helpers
    module Validatable
      def validate_and_save(object, validator_klass = nil)
        ::TalentHack::Services::Validator.new(object, validator_klass: validator_klass).call
      end
    end
  end
end