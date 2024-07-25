class Article < ApplicationRecord
  def process_article_updates(params, turn)
    if params.present? && !turn.article_update
      Article::ArticleUpdates.new(params).call
      turn.update(article_update: true)
    elsif params.nil?
      Error.create(error_type: 'article_update', message: 'Please select a week before trying to process Upgrade Admin.')
    else
      Error.create(error_type: 'article_update', message: 'Article Admin for that week has already been processed.')
    end
  end
end
