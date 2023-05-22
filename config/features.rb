# frozen_string_literal: true

module Configuration
  class Features
    def history_enabled?
      ENV.fetch('FEATURE_HISTORY_ENABLED', 'false') == 'true'
    end

    def ipfs_pages_enabled?
      ENV.fetch('FEATURE_IPFS_PAGES_ENABLED', 'true') == 'true'
    end
  end
end
