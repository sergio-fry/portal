# frozen_string_literal: true

class IpfsPolicy < ApplicationPolicy
  def show? = true
  def folder? = true
end
