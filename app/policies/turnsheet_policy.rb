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
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
