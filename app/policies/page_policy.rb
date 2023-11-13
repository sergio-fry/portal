# frozen_string_literal: true

class PagePolicy < ApplicationPolicy
  def show? = true
  def update? = authenticated?
  def rebuild? = authenticated?
  def edit? = update?
  def create? = authenticated?
  def new? = authenticated?

  class Scope < Scope
    def resolve
      Page.all
    end
  end
end
