class MessagesController < ApplicationController
  def index
    @messages = Messages.all
  end

  def show; end
end
