# frozen_string_literal: true

module Boundaries
  module Database
    class ApplicationRecord < ActiveRecord::Base
      primary_abstract_class
    end
  end
end
