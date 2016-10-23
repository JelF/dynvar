# frozen_string_literal: true
class DynVar
  # @api private
  # Container for DynVar values, acts as stack
  class Container
    # @param default_value generic value
    def initialize(default_value)
      self.stack = [default_value]
    end

    # pushes new value to use
    # @param x new value to be used
    def push(x)
      stack.push(x)
    end

    # pops current value to restore old version
    def pop
      stack.pop
    end

    # returns current value
    def head
      stack[-1]
    end

    # @api private
    # @return [DynVar::Container] new container with current value
    def fork
      self.class.new(head)
    end

    private

    # encapsulated storage
    # @return [Array]
    attr_accessor :stack
  end
end
