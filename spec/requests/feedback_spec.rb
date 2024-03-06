require 'rails_helper'

RSpec.describe "Feedbacks", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/feedback/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/feedback/create"
      expect(response).to have_http_status(:success)
    end
  end

end
