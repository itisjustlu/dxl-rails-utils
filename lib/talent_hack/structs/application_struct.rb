# frozen_string_literal: true

require 'dry-struct'

module TalentHack
  module Structs
    class ApplicationStruct < ::Dry::Struct
      class << self
        def attrs
          self.schema.keys.map(&:name)
        end
      end

      def assign_attributes(attrs)
        attrs.each do |key, value|
          self.attributes[key] = value
        end
      end
    end
  end
end
