# frozen_string_literal: true

module Configuration
  class Features
    def enabled?(name)
      case name
      when :history
        ENV.fetch('FEATURE_HISTORY_ENABLED', 'false') == 'true'
      else
        false
      end
    end
  end
end
