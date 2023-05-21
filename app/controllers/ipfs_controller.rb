# frozen_string_literal: true

class IpfsController < ApplicationController
  skip_forgery_protection

  def show
    authorize :ipfs

    if params[:filename]
      send_data Ipfs::Content.new(params[:cid]).data,
                filename: params[:filename],
                type: content_type
    else
      render inline: Ipfs::Content.new(params[:cid]).data
    end
  end

  def folder
    authorize :ipfs

    render inline: Ipfs::Folder.new(params[:cid]).file("#{params[:filename]}.#{params[:format]}").data,
           content_type:
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
end
