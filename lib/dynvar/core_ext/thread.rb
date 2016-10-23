# frozen_string_literal: true
class DynVar
  # DynVar core extensions
  module CoreExt
    # Extensions for ::Thread class
    module Thread
      ::Thread.prepend(self)

      # prepends DynVar::Table forking to thread creation
      def initialize(*)
        current_table = Table.instance

        super do |*args|
          self[Table::THREAD_VARIABLE] ||= current_table.fork
          yield(*args)
        end
      end
    end
  end
end
