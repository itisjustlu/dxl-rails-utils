# frozen_string_literal: true

module TalentHack
  module Serializers
    class ApplicationSerializer
      include ::JSONAPI::Serializer
      set_key_transform :camel_lower
    end
  end
end
