# frozen_string_literal: true

class AddUniqSlugConstraint < ActiveRecord::Migration[7.0]
  def change
    add_index :pages, :slug, unique: true
    change_column :pages, :slug, :string, null: false
  end
end
