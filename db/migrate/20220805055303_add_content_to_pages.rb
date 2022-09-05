# frozen_string_literal: true

class AddContentToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :content, :text
  end
end
