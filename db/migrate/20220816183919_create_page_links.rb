class CreatePageLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :page_links do |t|
      t.integer :page_id, null: false
      t.integer :target_page_id, null: false

      t.datetime :created_at
    end
  end
end
