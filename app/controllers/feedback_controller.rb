class FeedbackController < ApplicationController
  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      redirect_to help_path, notice: 'Feedback sent successfully.'
    else
      flash.now[:alert] = 'Error sending feedback. Please check the form.'
      render :new
    end
  end

  def new
    @feedback = Feedback.new
  end

  def close_feedback
    feedback = Feedback.find_by(id: params[:format])
    if feedback.update_attribute(:outstanding, false)
      flash[:notice] = 'Feedback closed successfully.'
    else
      flash[:alert] = 'Error closing feedback.'
    end
    redirect_to turns_gm_admin_path
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :club, :message, :feedback_type, :outstanding)
  end
end
