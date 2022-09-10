# frozen_string_literal: true

class CreatePageVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :page_versions do |t|
      t.integer :page_id
      t.string :ipfs_cid

      t.timestamps
    end

    add_foreign_key :page_versions, :pages
    add_index :page_versions, :page_id
  end
end
