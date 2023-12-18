# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController do
  describe '#show' do
    let(:url) do
      Url.shorten('http://test.com')
    end

    it 'renders full url' do
      get "/urls/#{url.short_url}"

      expect(response.parsed_body).to eq('full_url' => 'http://test.com')
    end

    it 'increment click_counter value' do
      expect { get "/urls/#{url.short_url}" }.to change { url.reload.click_counter }.by(1)
    end
  end

  describe '#stats' do
    let(:url) do
      Url.shorten('http://test.com')
    end

    it 'renders click counter' do
      get "/urls/#{url.short_url}/stats"

      expect(response.parsed_body).to eq('click_counter' => url.click_counter)
    end
  end

  describe '#create' do
    it 'creates url' do
      expect { post '/urls', params: { full_url: 'http://test.com' } }.to change(Url, :count).by(1)

      url = Url.last
      expect(response.parsed_body).to eq('full_url' => 'http://test.com', 'short_url' => url.short_url)
    end
  end
end
