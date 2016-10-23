# frozen_string_literal: true
require 'securerandom'
require 'dynvar/core_ext/thread'

# DynVar provides dynamic variables for ruby language.
# Usage example:
#   Context = DynVar.initialize({})
#   Context.set(locale: :ru) do
#     puts "Your locale is #{Context.get[:locale]}!"
#   end
class DynVar
  autoload :VERSION, 'dynvar/version'
  autoload :Container, 'dynvar/container'
  autoload :Table, 'dynvar/table'

  # @param default_value default value
  def initialize(default_value = nil)
    self.uuid = SecureRandom.uuid
    Table.instance[uuid] = Container.new(default_value)
  end

  # @return current value
  def get
    container.head
  end

  # @param x value to be used in block
  # @yield nothing
  def set(x)
    container.push(x)
    yield
  ensure
    container.pop
  end

  # redefined Object#inspect
  # @return [String]
  def inspect
    "#<DynVar:#{uuid} #{get.inspect}>"
  end

  # redefined Object#to_s
  # @return [String]
  def to_s
    get.to_s
  end

  private

  # @return [DynVar::Container] container of this variable for current thread
  # @raise [KeyError] on some internal errors
  def container
    Table.instance[uuid]
  rescue KeyError
    raise KeyError, <<~TXT
      Internal lookup error, check you have initialized DynVar instance
    TXT
  end

  # uuid, specified for this variable for lookups in DynVar::Table
  # @return [String]
  attr_accessor :uuid
end
