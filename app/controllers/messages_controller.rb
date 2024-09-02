class MessagesController < ApplicationController
  def index
    @message = Message.all
  end

  def show; end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      if @message.var2 == 'gm_email'
        UserMailer.gm_public_email(message_params).deliver_now
      end
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
    params.permit(:week, :club, :var1, :var2, :var3, :action_id)
  end
end
