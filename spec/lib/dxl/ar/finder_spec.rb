# frozen_string_literal: true

require 'spec_helper'
require 'pry'
RSpec.describe ::DXL::AR::Finder do
  subject { described_class.call(key: :organizations, object_class: Organization, opts: opts) }

  let!(:organization_1) { Organization.create(title: 'Test 1', created_at: 2.days.ago) }
  let!(:organization_2) { Organization.create(title: 'Test 2', created_at: 3.days.ago) }
  let!(:organization_3) { Organization.create(title: 'Test 3', created_at: 4.days.ago) }
  let!(:organization_4) { Organization.create(title: 'Test 4', created_at: 5.days.ago) }
  let!(:organization_5) { Organization.create(title: 'Test 5', created_at: 6.days.ago) }

  let(:organizations) { subject.organizations }
  let(:opts) { {} }

  describe '.call' do
    it 'returns in given key' do
      expect(subject.organizations).not_to be_nil
    end

    it 'returns all results' do
      expect(organizations.size).to eq(5)
    end
  end
end