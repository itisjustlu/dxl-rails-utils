# frozen_string_literal: true

module TalentHack
  module Structs
    module ApplicationStruct
      def initialize(attrs = {})
        attrs.each do |key, value|
          send("#{key}=", value)
        end
      end
    end
  end
end
