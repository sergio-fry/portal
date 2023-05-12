# frozen_string_literal: true

class PagesController
  class Page
    include ActiveModel::Validations

    validates :content, presence: true

    def initialize(page)
      @page = page
      @new_attrs = {}
    end

    def exists? = @page.exists?

    class Model
      def initialize(page)
        @page = page
      end

      def model_name = ModelName.new(@page)
      def persisted? = @page.exists?
    end

    class ModelName
      def initialize(page)
        @page = page
      end

      def param_key = 'page'
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

        true
      else
        false
      end
    end
  end
end
