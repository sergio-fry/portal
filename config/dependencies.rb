# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'

class DependenciesContainer
  extend Dry::Container::Mixin

  namespace 'ipfs' do
    register 'ipfs' do
      Boundaries::Ipfs::Ipfs.new
    end

    register 'gateway' do
      Boundaries::Ipfs::Gateway.new
    end
  end

  register 'pages' do
    Boundaries::Pages.new
  end

  namespace 'db' do
    register 'pages' do
      Boundaries::Database::Pages.new
    end
  end

  register 'features' do
    require_relative 'features'
    Configuration::Features.new
  end
end

Dependencies = Dry::AutoInject(DependenciesContainer)
