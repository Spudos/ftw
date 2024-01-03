json.extract! turnsheet, :id, :week, :club, :manager, :email, :created_at, :updated_at
json.url turnsheet_url(turnsheet, format: :json)
