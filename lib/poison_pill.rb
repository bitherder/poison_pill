class Object
  def __poison?; false; end
end

class PoisonPill < BasicObject
  class NotFulfilledError < ::StandardError; end
  def initialize(container, attr_name)
    @caller = ::Kernel.caller
    @called_line, @caller_line = @caller[0..1]
    @container = container
    @attr_name = attr_name
  end

  def __poison?; true; end
  def __origin__; @origin; end

  def __called_pathname__
    @called_pathname || __decode_called__.first
  end

  def __called_line_number__
    @called_line_number || __decode_called__[1]
  end

  def __caller_method_name__
    @caller_method_name ||= @caller_line[/:in\s+`(.*)'$/, 1].to_sym
  end

  def method_missing(method_name, *params, &block)
    message = "The attribute, #{@attr_name}, in #{@container.inspect} was not filled-in"

    if @container.respond_to?(:fulfilled?)
      message +=
        if @container.fulfilled?
          if @container.respond_to?(:fulfilled_message)
            @container.fulfilled_message
          else
            " even though #{@container.inspect} was fulfilled"
          end
        else
          if @container.respond_to?(:unfulfilled_message)
            @container.unfulfilled_message
          else
            ", because #{@container.inspect} was not fulfilled"
          end
        end
    end

    method_call = "#{method_name}(#{params.map(&:inspect).join(', ')})"
    message += " [triggered with call to #{method_call}]"

    message += "\n #{__called_pathname__}:#{__called_line_number__} in ##{__caller_method_name__}"

    ::Kernel.raise NotFulfilledError, message
  end

  private

  def __decode_called__
    f, l = @called_line.match(/^(.*?):(\d+)/).captures
    @called_pathname = f
    @called_line_number = l.to_i
    [@called_pathname, @called_line_number]
  end

end
