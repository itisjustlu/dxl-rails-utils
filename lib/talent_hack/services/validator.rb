# frozen_string_literal: true

module TalentHack
  module Services
    class Validator
      def initialize(object, attributes: nil, validator_class: nil, error_class: nil)
        @object = object
        @attributes = attributes || object.attributes
        @validator = validator_class&.new(@attributes) || build_validator
        @error_class = error_class
      end

      def call
        raise @error_class.new(@validator.errors.full_messages) unless @validator.valid?
      end

      private

      def build_validator
        "#{@object.class.name}Validator".constantize.new(@attributes)
      end
    end
  end
end