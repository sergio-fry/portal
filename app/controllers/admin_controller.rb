# frozen_string_literal: true

class AdminController < ApplicationController
  def index
    authorize :admin, :index?
  end
end
