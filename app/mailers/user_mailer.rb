class UserMailer < ApplicationMailer
  default from: 'gm@ftwpbem.com'

  def turn_submitted_email(user, turnsheet)
    @user = user
    @submitted_turnsheet = turnsheet

    mail(to: @user.email,
         subject: 'FTW turnsheet submitted',
         bcc: ['andyp@stinkyink.com'])
  end

  def turn_completed_email(week)
    users = User.all

    @week = week

    users.each do |user|
      mail(to: user.email,
           subject: "FTW week #{week} turn completed",
           bcc: ['andyp@stinkyink.com'])
    end
  end

  def gm_public_email(message_params)
    @message = message_params[:var1]
    @users = User.all

    @users.each do |user|
      mail(to: user.email,
           subject: "FTW message from the GM",
           bcc: ['andyp@stinkyink.com'])
    end
  end
end
