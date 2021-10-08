# frozen_string_literal: true

require 'spec_helper'

RSpec.describe "Interactor" do
  class InteractorError < TalentHack::Errors::ApplicationError; end

  class InteractorTestOne < TalentHack::Services::ApplicationService
    modulize :interactable
    error_class InteractorError

    def call
      context.is_test_one = true
    end
  end

  class InteractorTestOneError < TalentHack::Services::ApplicationService
    modulize :interactable
    error_class InteractorError

    def call
      context.error = "Some error"
      context.fail!
    end
  end

  class InteractorTest < TalentHack::Services::ApplicationService
    modulize :interactable
    error_class InteractorError

    organize ::InteractorTestOne,
             ->(context) { custom_method(context) }

    class << self
      def custom_method(context)
        context.is_lambda = true
      end
    end
  end

  class InteractorTestError < TalentHack::Services::ApplicationService
    modulize :interactable
    organize ::InteractorTestOneError,
             ->(context) { custom_method(context) }
  end

  class InteractorTestIfONe < TalentHack::Services::ApplicationService
    modulize :interactable
    def call
      context.is_test_if_one = true
    end
  end

  class InteractorTestIfSuccess < TalentHack::Services::ApplicationService
    modulize :interactable
    organize ::InteractorTestOne,
             ->(context) { custom_method(context) }

    organize_if ::InteractorTestIfONe,
                ->(context) { custom_if_method(context) },
                condition: ->(context) { context.is_test_one }

    class << self
      def custom_method(context)
        context.is_lambda = true
      end

      def custom_if_method(context)
        context.is_custom_if = true
      end
    end
  end

  class InteractorTestIfNo < TalentHack::Services::ApplicationService
    modulize :interactable
    organize ::InteractorTestOne,
             ->(context) { custom_method(context) }

    organize_if ::InteractorTestIfONe,
                ->(context) { custom_if_method(context) },
                condition: ->(context) { !context.is_test_one }

    class << self
      def custom_method(context)
        context.is_lambda = true
      end

      def custom_if_method(context)
        context.is_custom_if = true
      end
    end
  end

  describe '.call' do
    subject { ::InteractorTest.new.call }

    it 'should return success' do
      expect(subject).to be_success
    end

    it 'should return is_lambda context' do
      expect(subject.is_lambda).to be_truthy
    end

    it 'should return is_test_one context' do
      expect(subject.is_test_one).to be_truthy
    end

    context 'when interactor fails' do
      subject { ::InteractorTestError.new.call }

      it 'should raise an error' do
        expect { subject }.to raise_error(InteractorError) { |error|
          expect(error.message).to eq('Some error')
        }
      end
    end

    describe 'organize if' do
      context 'when should call ifs' do
        subject { InteractorTestIfSuccess.new.call }

        it 'should assign is_test_if_one' do
          expect(subject.is_test_if_one).to be_truthy
        end

        it 'should assign is_custom_if' do
          expect(subject.is_custom_if).to be_truthy
        end
      end

      context 'when should not call ifs' do
        subject { InteractorTestIfNo.new.call }

        it 'should assign is_test_if_one' do
          expect(subject.is_test_if_one).to be_nil
        end

        it 'should assign is_custom_if' do
          expect(subject.is_custom_if).to be_nil
        end
      end
    end
  end
end
