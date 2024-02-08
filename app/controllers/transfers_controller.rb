class TransfersController < ApplicationController
  def index
    @transfers = Transfer.all
  end

  def show
    @transfers = Transfer.find_by(params[:week])
  end

  def new; end

  def edit; end

  def create
    respond_to do |format|
      if @transfer.save
        format.html { redirect_to transfers_path, notice: "Transfer was successfully created." }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transfers.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @transfer.update
        format.html { redirect_to transfers_path, notice: "Transfer was successfully updated." }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transfers.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transfer.destroy

    respond_to do |format|
      format.html { redirect_to transfers_url, notice: "Transfer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def transfer_params
    params.require(:transfer).permit!
  end
end
