# frozen_string_literal: true

require 'interactor'

module DXL
  module Modules
    module InteractorModule
      def self.included(base)
        base.class_eval do
          include ::Interactor::Organizer
          extend ClassMethods
          include InstanceMethods
        end
      end

      module ClassMethods
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
