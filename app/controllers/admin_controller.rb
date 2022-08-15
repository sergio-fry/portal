class AdminController < ApplicationController
  def index
    authorize :admin, :index?
  end
end
