# frozen_string_literal: true

module DXL
  module AR
    class Configuration
      attr_accessor :per_page

      class << self
        def configuration
          @configuration ||= Configuration.new
        end

        def configure
          yield(configuration)
        end
      end
    end
  end
end