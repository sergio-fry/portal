require "http"

module Ipfs
  class Folder
    def initialize(cid, api_endpoint: ENV.fetch("IPFS_KUBO_API", "http://localhost:5001"))
      @cid = cid
      @http_client = HTTP
      @api_endpoint = api_endpoint
    end

    def dag
      res = @http_client.post(
        "#{@api_endpoint}/api/v0/dag/get",
        params: {arg: @cid}
      )

      if res.code >= 200 && res.code <= 299
        JSON.parse(res.body)
      else
        puts res.code
        raise res.body
      end
    end

    def content_at(path)
      dag.find path
    end
  end
end
