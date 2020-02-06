# Load the Rails application.
require_relative 'application'

class Logger
  class Formatter
    def call(severity, time, progname, msg)
      if msg.class.to_s == 'String'
        if msg.present? && msg.exclude?('assets') && msg.exclude?('slim')
          format = "[%s #%d] %5s -- %s: %s\n"
          format % ["#{time.strftime('%Y-%m-%d %H:%M:%S')}.#{'%06d' % time.usec.to_s}",$$, severity, progname, msg2str(msg)]
        end
      end
    end
  end
end

# Initialize the Rails application.
Rails.application.initialize!
