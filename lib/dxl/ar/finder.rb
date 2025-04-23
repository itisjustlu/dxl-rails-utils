# frozen_string_literal: true

require 'dxl/services/application_service'

module DXL
  module AR
    class Finder < ::DXL::Services::ApplicationService
      behave_as :interactor
      CONCERNS = [:associations, :comparison, :pagination, :order]

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

        def finders = @finders || []
      end

      delegate_to_context :key, :object_class, :opts

      def call
        init
        apply_concerns
        apply_finders
        assign_key
        distinct! if !!context.distinct
        count! if !!context.count
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

      def distinct!
        context.send("#{key}=", context.send(key).distinct)
      end

      def count!
        results = context.send(key).except(:offset, :limit, :order).count
        context.total_items = results
        context.total_pages = (results.to_f / context.per_page.to_f).ceil
      end
    end
  end
end
