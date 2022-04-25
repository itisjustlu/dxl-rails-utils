# frozen_string_literal: true

require 'dxl'
require 'rails'

module DXL
  class Engine < ::Rails::Engine

    isolate_namespace DXL
    engine_name 'dxl'

    def self.activate
    end
  end
end