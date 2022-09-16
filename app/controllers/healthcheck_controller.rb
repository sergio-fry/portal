# frozen_string_literal: true

class HealthcheckController < ApplicationController
  def index
    authorize :healthcheck, :check?
    render inline: "OK"
  end
end
