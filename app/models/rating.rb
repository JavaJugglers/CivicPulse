# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :news_item
  belongs_to :user

  validates :news_item, :user, presence: true

  def self.get_all_ratings(item)
    Rating.where(news_item_id: item.id)
  end

  def self.get_average(item)
    avg = 0
    len = 0
    get_all_ratings(item).each do |r|
      avg += r.score
      len += 1
    end
    format('%.2f', (avg.to_f / len))
  end
end
