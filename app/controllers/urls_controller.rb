# frozen_string_literal: true

class UrlsController < ApplicationController
  before_action :set_url, only: %i[show stats]

  def show
    @url.increment_click_counter

    render json: { full_url: @url.full_url }
  end

  def create
    url = Url.shorten(params[:full_url])

    render json: {
      full_url: url.full_url,
      short_url: url.short_url
    }
  end

  def stats
    render json: { click_counter: @url.click_counter }
  end

  private

  def set_url
    @url = Url.find_by!(short_url: params[:id])
  end
end
