# frozen_string_literal: true

require 'dry-struct'
require 'dxl/structs/application_struct'

module DXL
  module Structs
    class ApplicationStructArray < ::DXL::Structs::ApplicationStruct
      class << self
        def load(object)
          object = (object || [])
          object.map do |item|
            struct = allocate
            struct.__send__(:initialize, item.deep_symbolize_keys)
            struct
          end
        end
      end
    end
  end
end
