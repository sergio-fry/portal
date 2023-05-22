class RemoveHistoryIpfsCidFromPages < ActiveRecord::Migration[7.0]
  def change
    remove_column :pages, :history_ipfs_cid, :string
  end
end
