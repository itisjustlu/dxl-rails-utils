# frozen_string_literal: true

require 'dry-struct'

module DXL
  module Structs
    class ApplicationStruct < ::Dry::Struct
      class << self
        def attrs
          self.schema.keys.map(&:name)
        end

        def load(object)
          struct = allocate
          object = (object || {}).deep_symbolize_keys
          struct.__send__(:initialize, object)
          struct
        end

        def dump(object)
          JSON.parse(object.to_json)
        end
      end
    end
  end
end
