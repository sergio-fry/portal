require "http"
require "logger"

module Ipfs
  class Gateway
    class Error < StandardError
      def initialize(code, body)
        @code = code
        @body = body
      end

      def to_s
        "IPFS::Gateway ERROR #{@code}: #{@body}"
      end
    end

    def initialize(api_endpoint: ENV.fetch("IPFS_KUBO_API", "http://localhost:5001"), http: HTTP, logger: nil)
      @http_client = HTTP
      @api_endpoint = api_endpoint

      @logger = defined?(Rails) ? Rails.logger : Logger.new($stdout)
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
          @logger.info "Export content ##{cid} to IPFS"

          cid
        else
          raise Error.new(res.code, res.body)
        end
      end
    end

    def dag_put(dag)
      Tempfile.open("dag_json") do |file|
        file.write dag
        file.rewind

        res = @http_client.post(
          "#{@api_endpoint}/api/v0/dag/put",
          form: {
            file: HTTP::FormData::File.new(file)
          },
          params: {
            "store-codec" => "dag-pb"
          }
        )

        if res.code >= 200 && res.code <= 299
          cid = JSON.parse(res.body)["Hash"]
          @logger.info "Export content ##{cid} to IPFS"

          cid
        else
          raise Error.new(res.code, res.body)
        end
      end
    end
  end
end
