# frozen_string_literal: true

module Boundaries
  module Database
    class User < ApplicationRecord
      # Include default devise modules. Others available are:
      # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :registerable, recoverable
      devise :database_authenticatable, :rememberable, :validatable
    end
  end
end
