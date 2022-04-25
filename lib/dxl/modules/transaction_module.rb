# frozen_string_literal: true

module DXL
  module Modules
    module TransactionModule
      def with_transaction
        ActiveRecord::Base.transaction do
          yield
        end
      end
      # alias_method :ensure, :with_transaction
    end
  end
end
