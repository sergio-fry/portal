# frozen_string_literal: true

# This code is used inside IPFS pages

class Store
  def initialize
    @data = {}
  end
end

store = Store.new
puts 'Store init'
