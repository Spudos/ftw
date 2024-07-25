class ArticleUpdatesJob < ApplicationJob
  queue_as :default

  def perform(params)
    begin
      article = Article.new
      article.process_article_updates(params)
    rescue StandardError => e
      Error.create(
        error_type: 'ArticleUpdatesJob',
        message: e.message
      )
    end
  end
end
