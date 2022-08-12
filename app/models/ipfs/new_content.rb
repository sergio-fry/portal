module Ipfs
  class NewContent
    def initialize(data, api_endpoint: "http://localhost:5001")
      @data = data

      @api_endpoint = api_endpoint
      @http_client = HTTP
    end

    def cid
      Tempfile.open("ifps_file") do |file|
        file.write @data
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
          raise Error, res.body
        end
      end
    end

    def content
      Content.new(cid)
    end
  end
end
