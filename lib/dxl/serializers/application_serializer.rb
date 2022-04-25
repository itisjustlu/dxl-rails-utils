# frozen_string_literal: true

require 'jsonapi/serializer'

module DXL
  module Serializers
    class ApplicationSerializer
      include ::JSONAPI::Serializer
      set_key_transform :camel_lower
    end
  end
end
