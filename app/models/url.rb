# frozen_string_literal: true

class Url < ApplicationRecord
  validates :full_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :short_url, presence: true
  validates :click_counter, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  def self.shorten(full_url, short_url = '')
    short_url = Digest::SHA2.new.hexdigest(full_url)[0..5] if short_url.blank?
    url = Url.find_by(short_url:)

    return url if url&.full_url == full_url

    return create!(full_url:, short_url:) if url.blank?

    # just in case, when hexdigest is equal for different input
    shorten(full_url, short_url + SecureRandom.uuid[0..2])
  end

  def increment_click_counter
    self.class.update_counters(id, click_counter: 1)
  end
end
