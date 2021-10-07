# frozen_string_literal: true

module TalentHack
  module Errors
    class ApplicationError < StandardError
      attr_accessor :message
      attr_accessor :status

      def initialize(msg = nil, status = 422)
        @message = msg
        @status = status
        super(msg)
      end
    end
  end
end
