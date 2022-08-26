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

    def call_method_with_file(method, params:, data:)
      Tempfile.open("file") do |file|
        file.write data
        file.rewind

        res = @http_client.post(
          URI.join(@api_endpoint, method),
          form: {file: HTTP::FormData::File.new(file)},
          params: params
        )

        if res.code >= 200 && res.code <= 299
          JSON.parse(res.body)
        else
          raise Error.new(res.code, res.body)
        end
      end
    end

    def add(data)
      resp = call_method_with_file("/api/v0/add", params: {}, data: data)
      resp["Hash"]
    end

    def dag_put(dag)
      resp = call_method_with_file("/api/v0/add", params: {"store-codec" => "dag-pb"}, data: dag)
      resp.dig("Cid", "/")
    end
  end
end
