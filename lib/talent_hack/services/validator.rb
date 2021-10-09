# frozen_string_literal: true

module TalentHack
  module Services
    class Validator
      def initialize(object, validator_klass: nil)
        @object = object
        @validator = validator_klass&.new(object.attributes) || build_validator
      end

      def call
        return @object if @validator.valid? && @object.save

        @validator.errors.messages.each do |k, v|
          @object.errors.add k, v.first
        end

        @object
      end

      private

      def build_validator
        "#{@object.class.name}Validator".constantize.new(@object.attributes)
      end
    end
  end
end