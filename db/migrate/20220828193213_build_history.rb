# frozen_string_literal: true

class BuildHistory < ActiveRecord::Migration[7.0]
  def change
    Boundaries::Database::Page.find_each do |page|
      page.update(history_ipfs_cid: page.history_ipfs_content.cid)
    end
  end
end
