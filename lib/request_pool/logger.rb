module RequestPool
  # 日志
  class Logger
    class << self
      def log_path
        File.join(root_path, 'log', 'request_pool.log')
      end

      def logger
        @logger ||=
          if Object.const_defined?('Caishuo::LogStashLogger')
            Caishuo::LogStashLogger
          elsif Object.const_defined?('ActiveSupport::Logger')
            ActiveSupport::Logger
          end.try(:new, log_path)
      end

      def log(type, msg)
        logger ? logger.send(type, msg) : p(msg)
      rescue
        p msg
      end

      def info(msg)
        log(:info, msg)
      end

      def error(msg)
        log(:error, msg)
      end

      def root_path
        ENV['RAILS_ROOT'] || ENV['RACK_ROOT'] || ENV['PWD']
      end
    end
  end
end
