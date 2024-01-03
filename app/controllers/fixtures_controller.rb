class FixturesController < ApplicationController
  def index
    @fixtures = Fixtures.all
  end

  def show
  end
end