# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::DXL::Schemas::Builder do
  describe '.test1' do
    subject { described_class.new(serializer, klass, relationships: relationships).call }

    let(:serializer) { QuestionSerializer }
    let(:klass) { Question }
    let(:relationships) { nil }

    it 'returns the expected schema' do
      expect(subject).to eq({
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string, default: '0' },
              type: { type: :string, default: 'question' },
              attributes: {
                type: :object,
                properties: {
                  id: { type: :integer, nullable: true },
                  title: { type: :string, nullable: true },
                  data: {
                    type: :object,
                    properties: {
                      channel_id: { type: :string, nullable: true },
                      channel_name: { type: :string, nullable: true },
                      organization_data: {
                        type: :array,
                        items: {
                          type: :object,
                          properties: {
                            report_id: { type: :string, nullable: true },
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      })
    end
  end

  describe '.test2' do
    subject { described_class.new(serializer, klass, relationships: nil).call }

    let(:serializer) { OrganizationSerializer }
    let(:klass) { Organization }

    it 'returns the expected schema' do
      expect(subject).to eq({
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string, default: '0' },
              type: { type: :string, default: 'organization' },
              attributes: {
                type: :object,
                properties: {
                  id: { type: :integer, nullable: true },
                  data: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        report_id: { type: :string, nullable: true },
                      }
                    }
                  }
                }
              }
            }
          }
        }
      })
    end
  end
end