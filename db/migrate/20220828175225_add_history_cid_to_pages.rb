class AddHistoryCidToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :history_ipfs_cid, :string
  end
end
