json.extract! article, :id, :title, :message, :created_at, :updated_at
json.url article_url(article, format: :json)