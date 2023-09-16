# frozen_string_literal: true

class PagesController
  class NewPage
    include ActiveModel::Validations
    validates :slug, format: { with: /\A[a-zа-я0-9\-_]+\z/ }, presence: true
    validates :content, presence: true

    def initialize(params: {})
      @params = params
    end

    def exists? = false

    class Model
      def initialize(page)
        @page = page
      end

      def model_name = ModelName.new(@page)
      def persisted? = false
      def to_s = @page.slug
    end

    class ModelName
      def initialize(page)
        @page = page
      end

      def param_key = 'page'
      def route_key = 'page'
      def i18n_key = 'page'
      def human = 'page'
      def name = 'page'
      def singular_route_key = name
    end

    def policy_class = PagePolicy
    delegate :processed_content_with_layout, to: :page
    def slug = @params[:slug]
    def to_model = Model.new(self)
    def to_s = slug
    delegate :history, to: :page

    def page
      PageAggregate.new(
        id: nil,
        pages: DependenciesContainer.resolve(:pages),
        slug:,
        updated_at: nil,
        source_content: @params[:content]
      )
    end
  end
end
