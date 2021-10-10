# frozen_string_literal: true

module TalentHack
  module Modules
    module TransactionModule
      def with_transaction
        ActiveRecord::Base.transaction do
          yield
        end
      end
    end
  end
end
