# frozen_string_literal: true

require 'active_record'

module TalentHack
  module Models
    class ApplicationModel < ActiveRecord::Base
      self.abstract_class = true

      class << self
        def serialized_attributes
          @serialized_attributes ||= {}
        end

        def serialize(column, klass)
          serialized_attributes[column] = klass
          super(column, klass)
        end
      end
    end
  end
end
