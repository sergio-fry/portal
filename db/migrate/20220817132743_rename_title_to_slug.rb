class RenameTitleToSlug < ActiveRecord::Migration[7.0]
  def change
    rename_column :pages, :title, :slug
  end
end
