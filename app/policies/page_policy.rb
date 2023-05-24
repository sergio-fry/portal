# frozen_string_literal: true

class PagePolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    authenticated?
  end

  def rebuild?
    authenticated?
  end

  def edit? = update?

  class Scope < Scope
    def resolve
      Page.all
    end
  end
end
