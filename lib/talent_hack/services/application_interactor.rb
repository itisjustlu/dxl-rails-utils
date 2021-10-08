# frozen_string_literal: true

require 'active_support/core_ext/string'

module TalentHack
  module Services
    class ApplicationInteractor
      ERROR_CLASS = ""

      include ::Interactor
      include ::Interactor::Organizer

      class << self
        def error_class(klass)
          const_set("ERROR_CLASS", klass)
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
      end

      def call
        return organized_call if self.class.organized.length > 0

        super
      end

      def run!
        super
      rescue => e
        if Object.const_get("#{self.class}::ERROR_CLASS").present?
          raise "#{self.class}::ERROR_CLASS".constantize.new(e.context.error, e.context.status || 422)
        else
          raise ::Interactor::Failure.new(
            e.respond_to?(:context) ? e.context.error : e.message
          )
        end
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
    end
  end
end
