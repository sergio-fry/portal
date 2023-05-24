# frozen_string_literal: true

class PagesController
  class Page
    include ActiveModel::Validations
    include Dependencies[:pages]

    validates :content, :slug, presence: true

    def initialize(page, pages:)
      @page = page
      @new_attrs = {}
      @pages = pages
    end

    def exists? = @page.exists?

    class Model
      def initialize(page)
        @page = page
      end

      def model_name = ModelName.new(@page)
      def persisted? = @page.exists?
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
    def processed_content_with_layout = @page.processed_content_with_layout
    def slug = @page.slug
    def to_model = Model.new(self)
    def to_s = slug
    def history = @page.history

    def assign_attributes(new_attrs)
      @new_attrs = new_attrs
    end

    def content = @new_attrs[:content] || @page.source_content

    def save
      if valid?
        @page.source_content = content
        @page.move(@new_attrs[:slug]) if slug_changed?

        pages.save_aggregate @page

        true
      else
        false
      end
    end

    def slug_changed?
      @new_attrs[:slug] != @page.slug
    end
  end
end
