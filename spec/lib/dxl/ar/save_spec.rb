# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::DXL::AR::Save do
  subject { described_class.call!(question: question, key: :question) }

  let(:question) { Question.new(title: 'Test') }

  describe '.call' do
    it 'should save object' do
      expect { subject }.to change { Question.count }.by(1)
    end

    context 'when validation fails' do
      let(:question) { Question.new }

      it 'fails' do
        expect { subject }.to raise_error(DXL::Errors::AR::SaveError)
      end

      context 'passive call' do
        subject { described_class.call(question: question, key: :question) }

        it 'does not succeed' do
          expect(subject.success?).to eq(false)
        end
      end
    end
  end
end
