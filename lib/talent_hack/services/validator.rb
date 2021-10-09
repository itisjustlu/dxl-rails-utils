# frozen_string_literal: true

module TalentHack
  module Services
    class Validator
      def initialize(object, validator_class:, error_class:)
        @object = object
        @validator = validator_class&.new(object.attributes) || build_validator
        @error_class = error_class
      end

      def call
        raise @error_class.new(@validator.errors.full_messages) unless @validator.valid?
      end

      private

      def build_validator
        "#{@object.class.name}Validator".constantize.new(@object.attributes)
      end
    end
  end
end