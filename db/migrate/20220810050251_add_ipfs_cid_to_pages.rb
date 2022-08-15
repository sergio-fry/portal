class AddIpfsCidToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :ipfs_cid, :string
  end
end
