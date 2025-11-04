# frozen_string_literal: true

require 'active_record'
require 'jsonapi/serializer'

load File.dirname(__FILE__) + '/schema.rb'

class QuestionSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attribute :id, :title, :data
end

class OrganizationSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attribute :id, :data
end

class QuestionWithOrganizationSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attribute :id, :title, :data

  belongs_to :organization, serializer: OrganizationSerializer
end

class OrganizationHasManySerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attribute :id

  has_many :questions, serializer: QuestionWithOrganizationSerializer
end

class OrganizationHasOneSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attribute :id

  has_one :question, serializer: QuestionSerializer
end

class OrganizationHasManyDifferentKeySerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attribute :id

  has_many :answers, serializer: QuestionSerializer
end

class OrganizationEmptySerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attribute :id
end

class QuestionBelongsToOrganizationSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attribute :id

  belongs_to :organization, serializer: OrganizationEmptySerializer
end

class OrganizationHasOneQuestionQuestionBelongsToOrganization
  include JSONAPI::Serializer
  set_key_transform :camel_lower

  attribute :id

  has_one :question, serializer: QuestionBelongsToOrganizationSerializer
end

class Question < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :organization
end

class Organization < ActiveRecord::Base
  has_many :questions
  has_one :question

  has_many :answers, class_name: 'Question', foreign_key: :organization_id
end

class Comment < ActiveRecord::Base
  belongs_to :organization
end
