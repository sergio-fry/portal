# frozen_string_literal: true

class HealthcheckPolicy < ApplicationPolicy
  def check?
    true
  end
end
