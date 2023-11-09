# frozen_string_literal: true

module DXL
  module Errors
    class ApplicationError < StandardError
      attr_accessor :message
      attr_accessor :status

      def initialize(msg = nil, status = 422)
        @message = msg
        @status = status
        super(msg)
      end

      def context = Struct
                      .new(:error, :status)
                      .new(message, status)
    end
  end
end
