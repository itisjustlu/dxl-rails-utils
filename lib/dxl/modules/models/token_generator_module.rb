# frozen_string_literal: true

module DXL
  module Modules
    module Models
      class TokenGeneratorModule < Module
        attr_accessor :prefix, :attribute, :length, :only_numbers

        def initialize(opts = {})
          @prefix = opts.fetch(:prefix, nil)
          @attribute = opts.fetch(:attribute, :uuid)
          @length = opts.fetch(:length, 12)
          @only_numbers = opts.fetch(:only_numbers, false)
        end

        def included(host)
          generator_instance = self

          host.class_eval do
            validates(generator_instance.attribute, presence: true, uniqueness: { allow_blank: true })

            before_validation do |instance|
              if instance.send(generator_instance.attribute).blank?
                begin
                  instance.send("#{generator_instance.attribute}=", generator_instance.send(:generate_token))
                end while instance.class.exists?(generator_instance.attribute => instance.send(generator_instance.attribute))
              end
            end
          end
        end

        private

        def generate_token
          return "#{prefix}#{rand.to_s[2..length]}" if only_numbers
          content = SecureRandom.alphanumeric(length)
          return content unless prefix.present?
          "#{prefix}-#{content}"
        end
      end
    end
  end
end
