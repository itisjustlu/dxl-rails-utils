# frozen_string_literal: true

require 'active_record'

load File.dirname(__FILE__) + '/schema.rb'

class Question < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :organization
end

class Organization < ActiveRecord::Base
  has_many :questions
end
