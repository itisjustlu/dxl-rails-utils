# frozen_string_literal: true

require 'dxl/services/application_service'

module DXL
  module AR
    class Finder < ::DXL::Services::ApplicationService
      behave_as :interactor
      CONCERNS = [:associations, :comparison, :pagination, :order]
      DEFAULT_PER = 20

      CONCERNS.each do |concern|
        include "DXL::AR::Concerns::Finders::#{concern.to_s.camelize}".constantize
      end

      class << self
        def find(finder, only_if: -> (_) { true })
          @finders ||= []
          @finders.push(
            if: only_if,
            call: finder
          )
        end

        def finders
          @finders || []
        end
      end

      delegate_to_context :key, :object_class, :opts

      def call
        init
        apply_concerns
        apply_finders
        assign_key
      end

      private

      def init
        context.relation = object_class.all
      end

      def apply_concerns
        CONCERNS.each do |concern|
          send("apply_#{concern}")
        end
      end

      def apply_finders
        self.class.finders.each do |finder|
          if finder[:if].call(context.opts)
            context.relation = finder[:call].call(context.relation, context.opts)
          end
        end
      end

      def assign_key
        context.send("#{key}=", context.relation)
        context.relation = nil
      end
    end
  end
end
