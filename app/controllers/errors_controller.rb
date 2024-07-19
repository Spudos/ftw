class ErrorsController < ApplicationController
  def index
    @errors = Error.all
  end
end
