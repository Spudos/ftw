json.extract! article, :id, :week, :club_id, :image, :type, :headline, :sub_headline, :article, :created_at, :updated_at
json.url articles_url(article, format: :json)
