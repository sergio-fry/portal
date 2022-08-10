require "http"

class IpfsFile
  def initialize(content, cid: nil, api_endpoint: "http://localhost:5001")
    @content = content
    @cid = cid

    @api_endpoint = api_endpoint
    @http_client = HTTP
  end

  def cid
    return @cid if @cid.present?

    Tempfile.open("ifps_file") do |file|
      file.write @content
      file.rewind

      res = @http_client.post(
        "#{@api_endpoint}/api/v0/add",
        form: {
          file: HTTP::FormData::File.new(file)
        }
      )

      if res.code >= 200 && res.code <= 299
        @cid = JSON.parse(res.body)["Hash"]
        Rails.logger.info "Export content ##{@cid} to IPFS"
      else
        raise Error, res.body
      end

      @cid
    end
  end

  def url(filename: nil)
    result = "https://ipfs.io/ipfs/#{cid}"
    result = [result, URI.encode_www_form({filename: filename})].join("?") unless filename.nil?

    result
  end
end
