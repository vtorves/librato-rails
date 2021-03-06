module Librato
  module Rails
    module Subscribers

      # ActionController Status

      ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|

        event = ActiveSupport::Notifications::Event.new(*args)
        tags = { status: event.payload[:status] }

        unless tags[:status].blank?
          collector.group "rails.request" do |s|
            s.increment "status", tags: tags, inherit_tags: true
            s.timing "status.time", event.duration, tags: tags, inherit_tags: true
          end # end group
        end

      end # end subscribe

    end
  end
end
