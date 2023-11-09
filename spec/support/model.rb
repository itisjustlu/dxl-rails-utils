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

class QuestionWithOrganizationSerializer < ::DXL::Serializers::ApplicationSerializer
  attribute :id, :title, :data

  belongs_to :organization, serializer: OrganizationSerializer
end

class OrganizationHasManySerializer < ::DXL::Serializers::ApplicationSerializer
  attribute :id

  has_many :questions, serializer: QuestionWithOrganizationSerializer
end

class OrganizationHasOneSerializer < ::DXL::Serializers::ApplicationSerializer
  attribute :id

  has_one :question, serializer: QuestionSerializer
end

class OrganizationHasManyDifferentKeySerializer < ::DXL::Serializers::ApplicationSerializer
  attribute :id

  has_many :answers, serializer: QuestionSerializer
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
  has_one :question

  has_many :answers, class_name: 'Question', foreign_key: :organization_id

  attribute :data, OrganizationData.to_array_type
end

class Comment < ActiveRecord::Base
  belongs_to :organization
end
