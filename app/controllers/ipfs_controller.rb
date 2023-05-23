# frozen_string_literal: true

class IpfsController < ApplicationController
  skip_forgery_protection

  def show
    authorize :ipfs

    if params[:filename]
      send_data ipfs.content(params[:cid]).data,
                filename: params[:filename],
                type: content_type
    else
      render inline: ipfs.content(params[:cid]).data
    end
  end

  def folder
    authorize :ipfs

    if features.ipfs_pages_enabled?
      render inline: ipfs.folder(params[:cid]).file("#{params[:filename]}.#{params[:format]}").data,
             content_type:
    else
      render inline: 'not found', status: :not_found
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
end
