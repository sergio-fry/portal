# frozen_string_literal: true

class PagesController
  class NewPage
    include ActiveModel::Validations
    validates :slug, format: { with: /\A[a-zа-я0-9\-_]+\z/ }, presence: true
    validates :content, presence: true

    def initialize(params)
      @params = params
    end
  end
end
