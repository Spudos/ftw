class ErrorsController < ApplicationController
  def index
    @errors = Error.all
  end

  def destroy
    binding.pry
    @errors.destroy

    respond_to do |format|
      format.html { redirect_to turns_url, notice: 'Error cleared.' }
      format.json { head :no_content }
    end
  end
end
