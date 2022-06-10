# frozen_string_literal: true

require 'interactor'

module DXL
  module Modules
    module InteractorModule
      ERROR_CLASS = ""

      def self.included(base)
        base.class_eval do
          include ::Interactor::Organizer
          extend ClassMethods
          include InstanceMethods
        end
      end

      module ClassMethods
        def error_class(klass)
          const_set("ERROR_CLASS", klass)
        end

        def required_context(*args)
          args.each do |key|
            _required_keys << key
          end
          before_hooks.push(ensure_required(_required_keys))
        end

        def delegate_to_context(*args)
          delegate(*args, to: :context)
        end

        def organize(*interactors)
          @organized ||= []
          @organized.push(interactors).flatten!
        end

        def organize_if(*interactors, condition:)
          @organized ||= []
          @organized.push(
            items: interactors.flatten,
            if: condition
          )
        end

        private

        def _required_keys
          @__required_keys ||= []
        end

        def ensure_required(required)
          @_ensure_required ||= lambda do
            clean_hash_context = strip_nils(context.to_h)
            missing = (required - clean_hash_context.keys.map(&:to_sym))
            if missing.any?
              message = "Context is missing #{missing.join(', ')}"
              raise ::DXL::Errors::Interactors::MissingContextError, message
            end
          end
        end
      end

      module InstanceMethods
        def call
          return organized_call if self.class.organized.length > 0
          super
        end

        def run!
          super
        rescue => e
          if Object.const_get("#{self.class}::ERROR_CLASS").present?
            raise "#{self.class}::ERROR_CLASS".constantize.new(e.respond_to?(:context) ? (e.context.try(:error) || e.context) : e.message, e.context.status || 422)
          elsif e.is_a?(::DXL::Errors::Interactors::MissingContextError)
            raise e
          else
            raise ::Interactor::Failure.new(
              e.respond_to?(:context) ? (e.context.try(:error) || e.context) : e.message
            )
          end
        end

        def run
          super
        rescue => _
        end

        private

        def organized_call
          self.class.organized.each do |interactor|
            if interactor.is_a?(Hash)
              next unless interactor[:if].call(context)
              interactor[:items].each do |item|
                item.respond_to?(:call!) ? item.call!(context) : item.call(context)
              end
            else
              interactor.respond_to?(:call!) ? interactor.call!(context) : interactor.call(context)
            end
          end

          context
        end

        def strip_nils(hash)
          hash.reject { |_k, v| v.nil? }
        end
      end
    end
  end
end
