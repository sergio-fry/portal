module PagesHelper
  def ipfs_url(cid)
    "https://ipfs.io/ipfs/#{cid}/"
  end
end
