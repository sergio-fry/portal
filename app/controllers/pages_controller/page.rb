class PagesController
  class Page
    include ActiveModel::Validations

    validates :content, presence: true

    def initialize(page)
      @page = page
      @new_attrs = {}
    end

    def exists? = @page.exists?
    alias persisted? exists?

    def human = name
    def i18n_key = name
    def model_name = self
    def name = "page"
    def param_key = @page.slug
    def policy_class = PagePolicy
    def processed_content_with_layout = @page.processed_content_with_layout
    def slug = @page.slug
    def to_model = self
    def singular_route_key = name

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
