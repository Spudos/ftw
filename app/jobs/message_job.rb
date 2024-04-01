class MessageJob < ApplicationJob
  queue_as :default

  def perform
    Message.create(week: 99, club_id: 1, var1: "Test message from job")
  end
end
