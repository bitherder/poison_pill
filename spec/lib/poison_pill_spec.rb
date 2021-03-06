require 'spec_helper'

describe Object do
  it '#__poison?' do
    Object.new.__poison?.should be_false
  end
end

describe PoisonPill do
  let(:container) { "container" }

  def calling_method
    @file = __FILE__; @line_number = __LINE__
    @pill = PoisonPill.new(container, :some_attribute)
  end

  before do
    calling_method
  end

  it 'can be instantiated with an object and attribute name' do
    expect {
      PoisonPill.new("Bob", :size)
    }.to_not raise_error
  end

  it '#__poison?' do
    @pill.__poison?.should be_true
  end

  it 'raises a simple error message if the container does not implment #fulfilled?' do
    expect{ @pill.some_method }.to raise_error(
      PoisonPill::NotFulfilledError,
      /^The attribute, some_attribute, in "container" was not filled-in/
    )
  end

  context 'when the container implements #fulfilled?' do
    context ', if the container is fulfilled, ' do
      before{ stub(container).fulfilled?{ false } }

      it 'the pill raises an error with an un-fulfilled container message' do
        expect{ @pill.some_method }.to raise_error(
          PoisonPill::NotFulfilledError,
          /some_attribute.*"container".*because "container" was not fulfilled/
        )
      end

      it 'the pill raises an error with container specific un-fulfilled message if the container implements #unfulfilled_message' do
        stub(container).unfulfilled_message{ ", because something didn't happened" }
        expect{ @pill.some_method }.to raise_error(
          PoisonPill::NotFulfilledError,
          /some_attribute.*"container".*because something didn't happened/
        )
      end
    end

    context ', if the container is fulfilled, ' do
      before{ stub(container).fulfilled?{ true } }

      it 'the pill raises an error with an un-fulfilled container message' do
        expect{ @pill.some_method }.to raise_error(
          PoisonPill::NotFulfilledError,
          /some_attribute.*"container".*even though "container" was fulfilled/
        )
      end

      it 'the pill raises an error with an fulfilled container message if container is fulfilled' do
        stub(container).fulfilled_message{ " even though something happened" }
        expect{ @pill.some_method }.to raise_error(
          PoisonPill::NotFulfilledError,
          /some_attribute.*"container".*even though something happened/
        )
      end
    end
  end

  it 'raises a error with the called pathname' do
    expect{ @pill.some_method }.to raise_error(
      PoisonPill::NotFulfilledError,
      /#{@file}/
    )
  end

  it 'raises a error with the called line number' do
    expect{ @pill.some_method }.to raise_error(
      PoisonPill::NotFulfilledError,
      /#{@line_number+1}/
    )
  end

  it 'raises a error with the caller method' do
    expect{ @pill.some_method }.to raise_error(
      PoisonPill::NotFulfilledError,
      /#{@calling_method}/
    )
  end

  describe '#__called_pathname__' do
    it 'returns file where pill was filled in' do
      @pill.__called_pathname__.should == @file
    end
  end

  describe '#__called_line_number__' do
    it 'returns line where pill was filled in' do
      @pill.__called_line_number__.should == @line_number + 1
    end
  end

  describe '#__caller_method_name' do
    it 'returns caller method' do
      @pill.__caller_method_name__.should == :calling_method
    end
  end
end

