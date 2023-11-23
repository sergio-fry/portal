# frozen_string_literal: true

module Configuration
  class Features
    def history_enabled?
      ENV.fetch('FEATURE_HISTORY_ENABLED', 'false') == 'true'
    end
  end
end
