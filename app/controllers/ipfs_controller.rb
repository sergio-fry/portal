# frozen_string_literal: true

class IpfsController < ApplicationController
  skip_forgery_protection

  def show
    authorize :ipfs

    http_cache_forever(public: true) do
      if params[:filename]
        send_data cached_ipfs_data(params[:cid]),
                  filename: params[:filename],
                  type: content_type
      else
        render inline: cached_ipfs_data(params[:cid])
      end
    end
  end

  # TODO: http caching
  def folder
    authorize :ipfs

    http_cache_forever(public: true) do
      render inline: ipfs.folder(params[:cid]).file("#{params[:filename]}.#{params[:format]}").data,
             content_type:
    end
  end

  def content_type
    case File.extname(params[:filename])
    when '.css'
      'text/css'
    when '.js'
      'text/javascript'
    else
      'text/html'
    end
  end

  def features = DependenciesContainer.resolve :features

  def ipfs = DependenciesContainer.resolve 'ipfs.ipfs'

  def cached_ipfs_data(cid)
    Rails.cache.fetch("ipfs/#{cid}") { ipfs.content(cid).data }
  end
end
