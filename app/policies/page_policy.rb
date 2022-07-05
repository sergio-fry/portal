class PagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      Page.all
    end
  end
end
