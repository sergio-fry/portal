require "http"

class IpfsFile
  def initialize(content, api_endpoint: "http://localhost:5001")
    @content = content

    @api_endpoint = api_endpoint
    @http_client = HTTP
  end

  def cid
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
        JSON.parse(res.body)["Hash"]
      else
        raise Error, res.body
      end
    end
  end

  def url(filename: nil)
    URI::HTTPS.build(
      host: "ipfs.io",
      path: "/ipfs/#{cid}",
      query: URI.encode_www_form({filename: filename}.compact)
    ).to_s
  end
end
