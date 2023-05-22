# frozen_string_literal: true

namespace :populate do
  desc 'Populate all'
  task all: :environment do
    require 'ffaker'

    25.times do
      Page.new(FFaker::Internet.slug.remove(/[^a-b]+/)).source_content = FFaker::Lorem.paragraph
    end
  end
end
