class EmailTurnsheetJob < ApplicationJob
  queue_as :default

  def perform(user, turnsheet)
    UserMailer.turn_submitted_email(user, turnsheet).deliver_now
  rescue StandardError => e
    Error.create(
      error_type: 'EmailTurnsheetJob',
      message: e.message
    )
  end
end
