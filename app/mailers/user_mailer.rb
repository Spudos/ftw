class UserMailer < ApplicationMailer
  default from: 'gm@ftwpbem.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to FTW!')
  end

  def turn_submitted_email(user, turnsheet)
    @user = user
    @submitted_turnsheet = turnsheet

    mail(to: @user.email,
         subject: 'FTW turnsheet submitted',
         bcc: ['andyp@stinkyink.com'])
  end

  def turn_completed_email(week)
    users = User.all

    users.each do |user|
      mail(to: user.email,
           subject: "FTW week #{week} turn completed",
           bcc: ['andyp@stinkyink.com'])
    end
  end
end
