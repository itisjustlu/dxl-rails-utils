# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::DXL::AR::AssignAndSave do
  subject { described_class.call!(opts: opts, key: :question, object_class: Question) }

  let(:opts) { { title: 'Test' } }

  describe '.call' do
    it 'should save object' do
      expect { subject }.to change { Question.count }.by(1)
    end

    context 'when validation fails' do
      let(:opts) { { title: nil } }

      it 'fails' do
        expect { subject }.to raise_error(DXL::Errors::AR::SaveError)
      end
    end
  end
end
