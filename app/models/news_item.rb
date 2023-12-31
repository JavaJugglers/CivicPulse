# frozen_string_literal: true

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  @issues = ['Free Speech', 'Immigration', 'Terrorism', 'Social Security and Medicare', 'Abortion',
             'Student Loans', 'Gun Control', 'Unemployment', 'Climate Change', 'Homelessness', 'Racism', 'Tax Reform',
             'Net Neutrality', 'Religious Freedom', 'Border Security', 'Minimum Wage', 'Equal Pay'].freeze

  require 'rubygems'
  require 'news-api'
  @news_api = News.new(Rails.application.credentials[:News_API_KEY]).freeze

  # before_validation do |news_item|:check_url
  validates :issue, inclusion: { in: @issues, message: 'is not a valid issue' }
  validate :valid_news_article

  class << self
    attr_reader :issues
  end

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end

  def valid_news_article
    uri = URI.parse link
  rescue URI::InvalidURIError
    errors.add(:link, "is invalid. Please enter a valid url that starts with http:// or
    https:// and that doesn't contain spaces.")
  else
    errors.add(:link, 'is invalid. Please enter a valid url that starts with http:// or https://.') if uri.host.nil?
  end

  def self.get_articles(rep_id, issue)
    rep = Representative.find(rep_id)
    query = "#{rep.name} #{issue}"
    parse @news_api.get_everything(
      q:        query,
      language: 'en',
      sortBy:   'relevancy'
    ).first(5)
  end

  def self.parse(response)
    articles = []
    return articles if response.nil?

    response.each do |article|
      a = {
        title:       article.title,
        description: article.description,
        link:        article.url
      }
      articles.push(a)
    end
    articles
  end
end
