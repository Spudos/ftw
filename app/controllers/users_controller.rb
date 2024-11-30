class UsersController < ApplicationController
  def index
    @clubs = Club.where(id: current_user.club)
  end

  def user_admin
    @inactive_users = User.where(soft_delete: true).order(:id)
    @active_users = User.where(soft_delete: false).order(:id)
  end

  def soft_delete
    user = User.find_by(id: params[:user_id])
    user.soft_delete = !user.soft_delete
    user.save
    redirect_to users_user_admin_path
  end

  def resign
    club = Club.find_by(id: params[:club_id])
    club.managed = false
    club.save

    current_user.club = 0
    current_user.appointed = 0
    current_user.save

    Feedback.create(
      name: current_user.fname,
      email: current_user.email, club: club.id,
      message: "Manager resigned from #{club.name}.",
      feedback_type: 'resignation',
      outstanding: 'true'
    )

    week = Message.maximum(:week)
    club_id = club.id
    headline = "#{current_user.lname} Resigns!"
    sub_headline = "New Manager Needed at #{club.name}"
    article = "#{current_user.fname} #{current_user.lname} has resigned from his post as manager of #{club.name}.  The board and fans are shocked as the club begins its search for a successor."

    article(week, club_id, headline, sub_headline, article)

    Message.create(
      week:,
      club_id:,
      var1: "#{current_user.fname} #{current_user.lname}
             has resigned as manager",
      var2: 'game',
      action_id: "#{club.name}resign"
    )

    redirect_to root_path, notice: "You have resigned from #{club.name}."
  end

  def new_manager
    club = Club.find_by(id: params[:club_id])
    club.managed = true
    club.save

    current_user.club = club.id
    current_user.appointed = Date.today
    current_user.club_count += 1
    current_user.save

    Feedback.create(
      name: current_user.fname,
      email: current_user.email, club: club.id,
      message: "Manager took over #{club.name}.",
      feedback_type: 'appointed',
      outstanding: 'true'
    )

    week = Message.maximum(:week)
    club_id = club.id
    headline = "#{current_user.lname} Appointed"
    sub_headline = "New Manager at #{club.name}"
    article = "#{current_user.fname} #{current_user.lname} has been appointed as the new manager of #{club.name}.  The board are delighted at his appointment and are looking forward to a successful future."

    article(week, club_id, headline, sub_headline, article)

    Message.create(
      week:,
      club_id:,
      var1: "#{current_user.fname} #{current_user.lname} has been appointed as manager.",
      var2: 'game',
      action_id: "#{club.name}managed"
    )

    redirect_to root_path, notice: "You have been appointed as manager of #{club.name}."
  end

  private

  def article(week, club_id, headline, sub_headline, article)
    Article.create(
      week:,
      club_id:,
      image: 'club.jpg',
      article_type: 'Club',
      headline:,
      sub_headline:,
      article:
    )
  end
end
