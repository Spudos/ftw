class WelcomeController < ApplicationController
  def index
    highest_week = Article.maximum(:week)
    @latest_article = Article.where.not(article_type: 'gm').where(week: highest_week).order("RANDOM()").limit(3)
  end
end
