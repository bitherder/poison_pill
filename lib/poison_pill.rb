class Object
  def __poison?; false; end
end

class PoisonPill < BasicObject
  class NotFulfilledError < ::StandardError; end
  def initialize(container, attr_name)
    @container = container
    @attr_name = attr_name
  end

  def __posion?; true; end

  def method_missing(method_name, *params, &block)
    message = "The attribute, #{@attr_name}, in #{@container.inspect} was not filled-in"

    if @container.respond_to?(:fulfilled?)
      message +=
        if @container.fulfilled?
          " even though the associated REST call was completed"
        else
          ", because the associated REST call has not been completed"
        end
    end

    method_call = "#{method_name}(#{params.map(&:inspect).join(', ')})"
    message += " [triggered with call to #{method_call}]"

    ::Kernel.raise NotFulfilledError, message
  end
end
