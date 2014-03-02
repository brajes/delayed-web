module Delayed
  module Web
    class MongoidDecorator < SimpleDelegator
      def queue! now = Time.current
        update_attributes! run_at: now, failed_at: nil, last_error: nil
      end
    end
  end
end
