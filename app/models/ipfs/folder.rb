# frozen_string_literal: true

require 'http'
require_relative 'gateway'
require_relative 'content'

module Ipfs
  class Folder
    def initialize(cid, gateway: Gateway.new)
      @cid = cid
      @gateway = gateway
    end

    def dag
      cid_v1 = @gateway.cid_format(@cid, v: 1)
      @gateway.dag_get(cid_v1)
    end

    def file(path)
      Content.new(
        file_link(path).dig('Hash', '/')
      )
    end

    def url(*args)
      Content.new(@cid).url(*args)
    end

    private

    def file_link(path)
      result = dag['Links'].find do |link|
        link['Name'] == path
      end

      raise "File not found #{path}" if result.nil?

      result
    end
  end
end
