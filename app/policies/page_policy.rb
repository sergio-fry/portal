class PagePolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    authenticated?
  end

  def edit? = update?

  def destroy? = update?

  class Scope < Scope
    def resolve
      Page.all
    end
  end
end
