require "http"

module Ipfs
  class Gateway
    class Error < StandardError
      def initialize(code, body)
        @code = code
        @body = body
      end
    end

    def initialize(api_endpoint: ENV.fetch("IPFS_KUBO_API", "http://localhost:5001"), http: HTTP)
      @http_client = HTTP
      @api_endpoint = api_endpoint
    end

    def add(data)
      Tempfile.open("ifps_file") do |file|
        file.write data
        file.rewind

        res = @http_client.post(
          "#{@api_endpoint}/api/v0/add",
          form: {
            file: HTTP::FormData::File.new(file)
          }
        )

        if res.code >= 200 && res.code <= 299
          cid = JSON.parse(res.body)["Hash"]
          Rails.logger.info "Export content ##{cid} to IPFS"

          cid
        else
          raise Error.new(res.code,  res.body)
        end
      end
    end
  end
end
