# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy
  def index?
    authenticated?
  end
end
