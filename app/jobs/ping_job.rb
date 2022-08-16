class PingJob < ApplicationJob
  queue_as :default

  class MaxAttempts < StandardError; end

  def perform(url)
    @url = url
    @timeout = 60
    @max_attemnpts = 5
    @attempts = 0

    until success?
      @status = response.status
    end
  end

  class FailedResponse
    def status
      500
    end
  end

  def can_retry?
    @attempts < @max_attemnpts
  end

  def response
    raise MaxAttempts.new("Max retries reached") unless can_retry?

    @attempts += 1
    future = Concurrent::Future.execute do
      Rails.logger.info "Ping #{@url}"
      resp = HTTP.timeout(@timeout).get(@url)
      Rails.logger.debug resp.inspect

      resp
    end

    while future.pending?
      sleep 1
    end

    future.value || FailedResponse.new
  end

  def success?
    @status == 200
  end
end
