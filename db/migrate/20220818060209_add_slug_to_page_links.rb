class AddSlugToPageLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :page_links, :slug, :string
  end
end
