class HelpController < ApplicationController
  def index; end

  def club_creation
    @club_creation = Club.new
  end

  def manage
    @available_clubs = Club.where(managed: false, league: ['Premier League', 'Championship'])
  end

  def club_submission
    new_club = Club.new
    points = params[:club][:stadium_points].to_i +
             params[:club][:bank_points].to_i +
             params[:club][:fanbase_points].to_i

    if params[:club].values.all?(&:present?) && points == 15
      new_club.submission(params)

      current_user.club_count += 1
      current_user.save

      redirect_to root_path, notice: 'Club was successfully created.'
    else
      redirect_to request.referrer, alert: 'Some params are missing or incorrect.'
    end
  end

  def manager_list
    @managers = if @waiting_list
                  User.all
                else
                  User.where.not(club: 0)
                end
  end
end
