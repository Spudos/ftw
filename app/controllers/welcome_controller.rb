class WelcomeController < ApplicationController
  def index
    @latest_news = News.order(week: :desc).limit(3)
  end
end
