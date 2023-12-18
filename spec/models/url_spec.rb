# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url do
  describe 'validations' do
    subject(:url) { described_class.new }

    it { is_expected.to validate_presence_of(:full_url) }
    it { is_expected.to validate_presence_of(:short_url) }
    it { is_expected.to validate_numericality_of(:click_counter).is_greater_than_or_equal_to(0) }

    it 'validate full_url by pattern' do
      url.short_url = 'xxx'
      url.full_url = 'http://test.com'
      expect(url).to be_valid

      url.full_url = 'xxx://test.com'
      expect(url).not_to be_valid
    end
  end

  describe '.shorten' do
    it 'creates url record' do
      expect { described_class.shorten('http://test.com') }.to change(described_class, :count).by(1)
    end

    it 'creates unique short urls' do
      10.times { |i| described_class.shorten("http://test#{i}.com") }

      expect(described_class.pluck(:short_url).uniq.size).to eq(10)
    end

    context 'when full url already exists' do
      before { described_class.shorten('http://test.com') }

      it 'does not create new record and returns old record' do
        new_url = nil
        expect { new_url = described_class.shorten('http://test.com') }.not_to change(described_class, :count)
        expect(new_url.id).to be_present
      end
    end
  end
end
