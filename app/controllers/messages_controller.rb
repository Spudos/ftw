class MessagesController < ApplicationController
  def index
    @message = Message.all
  end

  def show; end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to request.referrer, notice: 'Message sent successfully.'
    else
      flash.now[:alert] = 'Error sending message. Please check the form.'
      redirect_to request.referrer
    end
  end

  def new
    @message = Message.new
  end

  private

  def message_params
    params.permit(:week, :club_id, :var1, :var2, :var3, :action_id)
  end
end
