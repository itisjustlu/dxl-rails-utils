# frozen_string_literal: true

module TalentHack
  module Models
    class ApplicationModel < ActiveRecord::Base
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
