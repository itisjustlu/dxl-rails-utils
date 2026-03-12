# frozen_string_literal: true

require 'spec_helper'

class OrganizationFinder < ::DXL::AR::Finder
  find_eq :title
  find_not_eq :title
  find_ilike :title
  find_ilike :questions_title
  find_gte :created_at
  find_lte :created_at
  find_gt :created_at
  find_lt :created_at
end

RSpec.describe ::DXL::AR::Finder do
  subject { described_class.call(key: :organizations, object_class: Organization, opts: opts) }

  let(:organizations) { subject.organizations }
  let(:opts) { {} }

  describe 'pagination' do
    let!(:organization_1) { Organization.create(title: 'Test 1', created_at: 2.days.ago) }
    let!(:organization_2) { Organization.create(title: 'Test 2', created_at: 3.days.ago) }
    let!(:organization_3) { Organization.create(title: 'Test 3', created_at: 4.days.ago) }
    let!(:organization_4) { Organization.create(title: 'Test 4', created_at: 5.days.ago) }
    let!(:organization_5) { Organization.create(title: 'Test 5', created_at: 6.days.ago) }

    it 'returns in given key' do
      expect(subject.organizations).not_to be_nil
    end

    it 'returns all results' do
      expect(organizations.size).to eq(5)
    end

    context 'with page param' do
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

  describe 'comparison' do
    subject { OrganizationFinder.call(key: :organizations, object_class: Organization, opts: opts) }

    let!(:org_alpha) { Organization.create(title: 'Alpha', created_at: 2.days.ago) }
    let!(:org_beta) { Organization.create(title: 'Beta', created_at: 3.days.ago) }
    let!(:org_gamma) { Organization.create(title: 'Gamma', created_at: 4.days.ago) }

    describe 'find_eq' do
      let(:opts) { { title_eq: 'Alpha' } }

      it 'filters by exact match' do
        expect(organizations.size).to eq(1)
        expect(organizations.first.title).to eq('Alpha')
      end
    end

    describe 'find_not_eq' do
      let(:opts) { { title_not_eq: 'Alpha' } }

      it 'excludes exact match' do
        expect(organizations.size).to eq(2)
        expect(organizations.map(&:title)).not_to include('Alpha')
      end
    end

    describe 'find_ilike' do
      let(:opts) { { title_i_cont: 'lph' } }

      it 'filters by case-insensitive partial match' do
        expect(organizations.size).to eq(1)
        expect(organizations.first.title).to eq('Alpha')
      end
    end

    describe 'find_gte' do
      let(:opts) { { created_at_gteq: 3.days.ago.beginning_of_day } }

      it 'filters by greater than or equal' do
        expect(organizations.map(&:title)).to contain_exactly('Alpha', 'Beta')
      end
    end

    describe 'find_lte' do
      let(:opts) { { created_at_lteq: 3.days.ago.end_of_day } }

      it 'filters by less than or equal' do
        expect(organizations.map(&:title)).to contain_exactly('Beta', 'Gamma')
      end
    end

    describe 'find_gt' do
      let(:opts) { { created_at_gt: 3.days.ago.end_of_day } }

      it 'filters by greater than' do
        expect(organizations.size).to eq(1)
        expect(organizations.first.title).to eq('Alpha')
      end
    end

    describe 'find_lt' do
      let(:opts) { { created_at_lt: 3.days.ago.beginning_of_day } }

      it 'filters by less than' do
        expect(organizations.size).to eq(1)
        expect(organizations.first.title).to eq('Gamma')
      end
    end

    context 'with empty value' do
      let(:opts) { { title_eq: '' } }

      it 'ignores empty params' do
        expect(organizations.size).to eq(3)
      end
    end

    context 'with nil value' do
      let(:opts) { { title_eq: nil } }

      it 'ignores nil params' do
        expect(organizations.size).to eq(3)
      end
    end

    context 'with undeclared key' do
      let(:opts) { { secret_eq: 'anything' } }

      it 'ignores undeclared ransack keys' do
        expect(organizations.size).to eq(3)
      end
    end
  end

  describe 'legacy parameter aliases' do
    subject { OrganizationFinder.call(key: :organizations, object_class: Organization, opts: opts) }

    let!(:org_alpha) { Organization.create(title: 'Alpha', created_at: 2.days.ago) }
    let!(:org_beta) { Organization.create(title: 'Beta', created_at: 3.days.ago) }
    let!(:org_gamma) { Organization.create(title: 'Gamma', created_at: 4.days.ago) }

    context 'title_matching (legacy find_ilike)' do
      let(:opts) { { title_matching: 'lph' } }

      it 'filters by case-insensitive partial match' do
        expect(organizations.size).to eq(1)
        expect(organizations.first.title).to eq('Alpha')
      end
    end

    context 'created_at_gte (legacy find_gte)' do
      let(:opts) { { created_at_gte: 3.days.ago.beginning_of_day } }

      it 'filters by greater than or equal' do
        expect(organizations.map(&:title)).to contain_exactly('Alpha', 'Beta')
      end
    end

    context 'created_at_lte (legacy find_lte)' do
      let(:opts) { { created_at_lte: 3.days.ago.end_of_day } }

      it 'filters by less than or equal' do
        expect(organizations.map(&:title)).to contain_exactly('Beta', 'Gamma')
      end
    end
  end

  describe 'find_ilike on associated table' do
    subject { OrganizationFinder.call(key: :organizations, object_class: Organization, opts: opts) }

    let!(:org_alpha) { Organization.create(title: 'Alpha') }
    let!(:org_beta) { Organization.create(title: 'Beta') }
    let!(:question_1) { Question.create(title: 'Q about Alpha', organization: org_alpha) }
    let!(:question_2) { Question.create(title: 'Q about Beta', organization: org_beta) }

    let(:opts) { { questions_title_i_cont: 'Alpha' } }

    it 'filters by associated table column' do
      expect(organizations.size).to eq(1)
      expect(organizations.first.title).to eq('Alpha')
    end
  end

  describe 'ransack sort' do
    let!(:org_alpha) { Organization.create(title: 'Alpha') }
    let!(:org_beta) { Organization.create(title: 'Beta') }
    let!(:org_gamma) { Organization.create(title: 'Gamma') }

    let(:opts) { { s: 'title asc' } }

    it 'sorts using ransack format' do
      expect(organizations.map(&:title)).to eq(%w(Alpha Beta Gamma))
    end
  end

  describe 'default order' do
    let!(:org_alpha) { Organization.create(title: 'Alpha') }
    let!(:org_beta) { Organization.create(title: 'Beta') }
    let!(:org_gamma) { Organization.create(title: 'Gamma') }

    it 'orders by id desc by default' do
      expect(organizations.first.title).to eq('Gamma')
      expect(organizations.last.title).to eq('Alpha')
    end
  end
end
