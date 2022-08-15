class AdminPolicy < ApplicationPolicy
  def index?
    authenticated?
  end
end
