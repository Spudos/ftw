class UsersController < ApplicationController
  def index; end

  def resign
    club = Club.find_by(id: current_user.club)
    club.managed = false
    club.save

    current_user.club = 0
    current_user.save

    Feedback.create(name: current_user.fname,
                    email: current_user.email, club: club.id,
                    message: "Manager resigned from #{club.name}.",
                    feedback_type: 'resignation',
                    outstanding: 'true')

    redirect_to root_path, notice: "You have resigned from #{club.name}."
  end
end
