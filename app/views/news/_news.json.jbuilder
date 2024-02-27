json.extract! news, :id, :week, :club_id, :image, :type, :headline, :sub_headline, :article, :created_at, :updated_at
json.url news_url(news, format: :json)
