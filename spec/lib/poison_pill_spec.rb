describe PoisonPill do
  let(:container) { "container" }
  let(:pill) { PoisonPill.new(container, :some_attribute) }

  it 'can be instantiated with an object and attribute name' do
    expect {
      PoisonPill.new("Bob", :size)
    }.to_not raise_error
  end

  it 'raises a simple error message if the container does not implment #fulfilled?' do
    expect{ pill.some_method }.to raise_error(
      PoisonPill::NotFulfilledError,
      /^The attribute, some_attribute, in "container" was not filled-in/
    )
  end

  it 'raises a error with an un-fulfilled container message if container un-fulfilled' do
    stub(container).fulfilled?{ false }
    expect{ pill.some_method }.to raise_error(
      PoisonPill::NotFulfilledError,
      /some_attribute.*"container".*because the associated REST call has not been completed/
    )
  end

  it 'raises a error with an fulfilled container message if container is fulfilled' do
    stub(container).fulfilled?{ true }
    expect{ pill.some_method }.to raise_error(
      PoisonPill::NotFulfilledError,
      /some_attribute.*"container".*even though the associated REST call was completed/
    )
  end
end

