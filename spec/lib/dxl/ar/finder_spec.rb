# frozen_string_literal: true

require 'spec_helper'

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

    describe '.pagination' do
      let(:opts) { { page: 1 } }

      it 'returns paginated results' do
        expect(organizations.size).to eq(5)
      end

      it 'returns page' do
        expect(subject.page).to eq(1)
      end

      it 'returns per' do
        expect(subject.per_page).to eq(20)
      end

      context 'when per_page is set' do
        let(:opts) { { page: 1, per: 2 } }

        it 'returns paginated results' do
          expect(organizations.size).to eq(2)
        end
      end

      context 'when configuration is set' do
        let(:opts) { { page: 1 } }

        before do
          DXL::AR::Configuration.configure do |config|
            config.per_page = 3
          end
        end

        it 'returns paginated results' do
          expect(organizations.size).to eq(3)
        end

        it 'returns page' do
          expect(subject.page).to eq(1)
        end

        it 'returns per' do
          expect(subject.per_page).to eq(3)
        end

        context 'when context count is true' do
          subject { described_class.call(key: :organizations, object_class: Organization, opts: opts, count: true) }

          it 'returns total pages' do
            expect(subject.total_pages).to eq(2)
          end
        end
      end
    end
  end
end