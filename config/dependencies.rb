# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'

class DependenciesContainer
  extend Dry::Container::Mixin

  register 'ipfs' do
    Ipfs::Gateway.new
  end

  register 'pages' do
    Boundaries::Database::Pages.new
  end

  register 'features' do
    require_relative 'features'
    Configuration::Features.new
  end
end

Dependencies = Dry::AutoInject(DependenciesContainer)
