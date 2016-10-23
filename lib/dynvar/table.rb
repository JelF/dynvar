# frozen_string_literal: true
class DynVar
  # @api private
  # Lazy-frokable table of all `DynVar`s defined
  class Table
    # Thread variable name for table instance in current thread
    THREAD_VARIABLE = 'DynVar::Table.instance'

    # Contains all fallbacks for thread variables
    # It would be used, if variable initialized inside non-parent thread
    # @return [Hash(String, DynVar::Container)]
    def self.fallbacks
      @fallbacks ||= {}
    end

    # Instance accessor. DynVar::Table is not a singleton,
    # it's instances are thread-local
    # @return [DynVar::Table] instance of current thread
    def self.instance
      Thread.current[THREAD_VARIABLE] ||= new
    end

    def initialize
      self.table = {}

      table.default_proc = lambda do |_, key|
        table[key] = Table.fallbacks.fetch(key).dup
      end
    end

    # Lookups dynvar over table
    # @param key [String] uuid of dynvar
    # @return [DynVar::Container]
    def [](key)
      table[key]
    end

    # @api private
    # Pushes Dynvar::Container inside a table
    # @param key [String] uuid
    # @param value [DynVar::Container] container for DynVar values
    def []=(key, value)
      raise KeyError, <<~TXT if table.key?(key)
        #{key} already defined in DynVar::Table
      TXT

      table[key] = value
      Table.fallbacks[key] ||= value.dup.freeze
    end

    # @api private
    # @return [DynVar::Table]
    #   new table, which can lazy-load values from current
    def fork
      forked_table = Table.new

      forked_table.table.default_proc = lambda do |_, key|
        forked_table.table[key] = self[key]&.fork
      end

      forked_table
    end

    protected

    # @api private
    # encapsulated storage
    # @return [DynVar(String, DynVar::Container)]
    attr_accessor :table
  end
end
