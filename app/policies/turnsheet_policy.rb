# frozen_string_literal: true

class TurnsheetPolicy < ApplicationPolicy
  attr_reader :user, :turnsheet

  def initialize(user, turnsheet)
    @user = user
    @turnsheet = turnsheet
  end

  def index?
    false
  end

  def show?
    user.gm?
  end

  def create?
    user.gm?
  end

  def new?
    create?
  end

  def update?
    user.gm?
  end

  def edit?
    update?
  end

  def destroy?
    user.gm?
  end

  def process_turnsheet?
    user.gm?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: current_user.club)
      end
    end

    private

    attr_reader :user, :scope
  end
end
