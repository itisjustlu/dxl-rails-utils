# frozen_string_literal: true

require 'active_record'
require 'store_model'

load File.dirname(__FILE__) + '/schema.rb'

class QuestionSerializer < ::DXL::Serializers::ApplicationSerializer
  attribute :id, :title, :data
end

class OrganizationSerializer < ::DXL::Serializers::ApplicationSerializer
  attribute :id, :data
end

class OrganizationData
  include StoreModel::Model

  attribute :report_id, :string
end

class QuestionData
  include StoreModel::Model

  attribute :channel_id, :string
  attribute :channel_name, :string
  attribute :organization_data, OrganizationData.to_array_type
end

class Question < ActiveRecord::Base
  validates :title, presence: true

  attribute :data, QuestionData.to_type

  belongs_to :organization
end

class Organization < ActiveRecord::Base
  has_many :questions

  attribute :data, OrganizationData.to_array_type
end
