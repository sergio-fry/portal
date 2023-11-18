# frozen_string_literal: true

class PagesController
  class NewPage
    include ActiveModel::Validations
    validates :slug, format: { with: /\A[a-zа-я0-9\-_]+\z/ }, presence: true
    validates :source_content, presence: true

    include Dependencies[:pages]

    def initialize(params: {}, context:, pages:)
      @params = params
      @context = context
      @pages = pages
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
    def source_content = @params[:content]
    def to_model = Model.new(self)
    def to_s = slug
    delegate :history, to: :page

    def page
      @page ||= ::Page.new(
        id: nil,
        pages: DependenciesContainer.resolve(:pages),
        slug:,
        updated_at: Time.now,
        source_content:
      )
    end

    def save_url = @context.pages_url
    def save_method = :post

    def save
      if valid?
        pages.save_aggregate page

        true
      else
        false
      end
    end
  end
end
